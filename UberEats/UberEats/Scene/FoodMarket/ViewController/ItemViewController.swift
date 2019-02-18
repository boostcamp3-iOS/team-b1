//
//  ItemViewController.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit
import CoreLocation
import Service
import DependencyContainer
import ServiceInterface
import Common

class ItemViewController: UIViewController, UIScrollViewDelegate {

    private let locationManager = CLLocationManager()

    @IBOutlet var tableView: UITableView!

    // MARK: - ScrollView
    @IBOutlet var scrollView: UIScrollView!

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: self.leftPaddingOfPageControl,
                                                      y: heightOfScrollView - heightOfPageControl,
                                                      width: widthOfPageControl,
                                                      height: heightOfPageControl))
        pageControl.currentPage = 0
        return pageControl
    }()

    private var bannerTimer: Timer!

    private var isScrolledByUser: Bool!

    // MARK: - Magic Number
    private lazy var heightOfScrollView: CGFloat = {
         return self.view.frame.height * 0.3
    }()

    private lazy var widthOfPageControl: CGFloat = {
       return self.view.frame.width - 280
    }()

    private let leftPaddingOfPageControl: CGFloat = 30

    private let heightOfPageControl: CGFloat = 37

    private  lazy var heightOfFooter: CGFloat = {
        return self.view.frame.height * (10 / 812)
    }()

    private static let bannerTimeInterval: TimeInterval = 4

    private static let numberOfSection = 8

    private let RecommendCollectionViewCellNIB = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
    private let ExpectTimeCollectionViewCellNIB = UINib(nibName: "ExpectTimeCollectionViewCell", bundle: nil)
    private let NewRestCollectionViewCellNIB = UINib(nibName: "NewRestCollectionViewCell", bundle: nil)
    private let NearestCollectionViewCellNIB = UINib(nibName: "NearestCollectionViewCell", bundle: nil)

    private let seeMoreRestTableViewCellNIB = UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)

    // MARK: - Data
    private var foodMarketService: FoodMarketService = DependencyContainer.share.getDependency(key: .foodMarketService)

    private var recommendFood: [Food] = [] {
        didSet {
            let indexPath = IndexPath(row: 0, section: 1)
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return
            }
            tablecell.collectionView.reloadData()
        }
    }

    private var bannerImagesURL: [String] = [] {
        didSet {
            setupScrollView()
        }
    }

    private var nearestRests: [Store] = [] {
        didSet {
            let indexPath = IndexPath(row: 0, section: 2)
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return
            }
            tablecell.collectionView.reloadData()
        }
    }

    private var expectTimeRests: [Store] = [] {
        didSet {
            let indexPath = IndexPath(row: 0, section: 3)
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return
            }

            tablecell.collectionView.reloadData()
        }
    }

    private var newRests: [Store] = [] {
        didSet {
            let indexPath = IndexPath(row: 0, section: 4)
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return
            }
            tablecell.collectionView.reloadData()
        }
    }

    private let tableNIB = UINib(nibName: "TableViewCell", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationAuthority()

        initFoodMarket()
        setupTableView()
        //setupScrollView()

        isScrolledByUser = false

        bannerTimer = Timer.scheduledTimer(timeInterval: ItemViewController.bannerTimeInterval, target: self,
                                           selector: #selector(scrolledBanner), userInfo: nil, repeats: true)

    }

    @IBAction func touchUpSettingLocation(_ sender: Any) {
        present(SettingLocationViewController(), animated: true, completion: nil)
    }

    private func setupLocationAuthority() {
        // 위치 권한 요청
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }

    private func initFoodMarket() {
        foodMarketService.requestFoodMarket(dispatchQueue: DispatchQueue.global()) { [weak self] (dataResponse) in
            if dataResponse.isSuccess {

                guard let recommendFood = dataResponse.value?.recommendFood else {
                    return
                }

                guard let nearestRest = dataResponse.value?.nearestRest else {
                    return
                }

                guard let bannerImagesURL = dataResponse.value?.bannerImages else {
                    return
                }

                guard let exepectTimeRests = dataResponse.value?.expectTimeRest else {
                    return
                }

                guard let newRests = dataResponse.value?.newRests else {
                    return
                }

                self?.nearestRests = nearestRest
                //호출 순서가 이거보다 addbannerImage가 더 빠르다.
                self?.bannerImagesURL = bannerImagesURL

                self?.expectTimeRests = exepectTimeRests
                self?.recommendFood = recommendFood
                self?.newRests = newRests

                self?.tableView.reloadData()
            } else {
                fatalError()
            }
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false

        tableView.addSubview(pageControl)
        tableView.bringSubviewToFront(pageControl)
        tableView.register(tableNIB, forCellReuseIdentifier: "TableViewCellId")
        tableView.register(seeMoreRestTableViewCellNIB, forCellReuseIdentifier: "SeeMoreRestTableViewCellId")
    }

    @objc func scrolledBanner() {
        let nextPageOfPageControl: Int = pageControl.currentPage + 1

        let point = nextPageOfPageControl >= bannerImagesURL.count ?
            CGPoint.zero :
            CGPoint(x: view.frame.width * CGFloat(nextPageOfPageControl), y: 0)

        scrollView.setContentOffset(point, animated: true)
    }

    private func  addBannerImageView() {
        var frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)

        for index in 0..<bannerImagesURL.count {
            frame.origin.x = view.frame.width * CGFloat(index)
            frame.size = scrollView.frame.size

            let bannerImage = UIImageView(frame: frame)

            let imageURL = URL(string: bannerImagesURL[index])!

            ImageNetworkManager.shared.getImageByCache(imageURL: imageURL, complection: { (downloadImage, _) in
                bannerImage.image = downloadImage
            })

            scrollView.addSubview(bannerImage)
        }

    }

    private func setupPageControl() {
        pageControl.numberOfPages = bannerImagesURL.count
        pageControl.addTarget(self, action: #selector(changePage), for: .valueChanged)
    }

    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        scrollView.frame = CGRect(origin: CGPoint.zero,
                                  size: CGSize(width: view.frame.width, height: heightOfScrollView))

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(bannerImagesURL.count),
                                        height: scrollView.frame.height)

        addBannerImageView()
        setupPageControl()
    }

    @objc private func changePage() {
        var frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        let changedPageNumber = pageControl.currentPage
        scrollView.frame.origin = CGPoint(x: frame.size.width * CGFloat(changedPageNumber), y: 0)
        scrollView.scrollRectToVisible(scrollView.frame, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bannerTimer.invalidate()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        bannerTimer = Timer.scheduledTimer(timeInterval: 4, target: self,
                                           selector: #selector(scrolledBanner), userInfo: nil, repeats: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = pageIndex
        }
    }

}

// MARK: - TabelViewDelegate
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemViewController.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //enum의 연관값 사용!
        let section = Section(rawValue: section)!
        switch section {
        case .bannerScroll, .recommendFood, .nearestRest, .expectedTime, .newRest, .discount, .searchAndSee:
            return section.numberOfSection
        case .moreRest:
            return 10
        }
    }

    func setupTableViewCell(indexPath: IndexPath) -> TableViewCell {
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                            for: indexPath) as? TableViewCell else {
                                                                return .init()
        }

        tablecell.collectionView.tag = indexPath.section

        return tablecell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!

        switch section {
        case .bannerScroll:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            NSLayoutConstraint.activate(
                [
                    scrollView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor),
                    scrollView.topAnchor.constraint(equalTo: tablecell.topAnchor),
                    scrollView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor),
                    scrollView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor)
                ]
            )
            return tablecell
        case .recommendFood:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section

            tablecell.collectionView.register(RecommendCollectionViewCellNIB, forCellWithReuseIdentifier: "RecommendCollectionViewCellId")
            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell
        case .newRest:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.collectionView.register(NewRestCollectionViewCellNIB, forCellWithReuseIdentifier: "NewRestCollectionViewCellId")
            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell
        case .expectedTime:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.collectionView.register(ExpectTimeCollectionViewCellNIB, forCellWithReuseIdentifier: "ExpectTimeCollectionViewCellId")
            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell
        case .nearestRest:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.collectionView.register(NearestCollectionViewCellNIB, forCellWithReuseIdentifier: "NearestCollectionViewCellId")

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.isHidden = false

            return tablecell
        case .discount:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            //tablecell.collectionView.removeFromSuperview()
            tablecell.collectionView.isHidden = true

            return tablecell
        case .moreRest:
            if indexPath.row != 0 {
                guard let tablecellOfsixCell = tableView.dequeueReusableCell(
                    withIdentifier: "SeeMoreRestTableViewCellId",
                    for: indexPath) as? SeeMoreRestTableViewCell else {
                        return .init()
                }
                return tablecellOfsixCell
            } else {
                return .init()
            }

        case .searchAndSee:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            //tablecell.collectionView.removeFromSuperview()
            tablecell.collectionView.isHidden = true
            return tablecell
        }

        return .init()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .moreRest:
            if indexPath.row == 0 {
                return 80
            } else {
                return section.heightOfTableViewCell()
            }
        default:
            return section.heightOfTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        print("redraw \(indexPath.section):\(indexPath.row)")
    }

}

// MARK: - CollectionViewDelegate
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let section = Section(rawValue: collectionView.tag)!
        switch section {
        case .bannerScroll:
            return 0
        case .recommendFood:
            return recommendFood.count
        case .nearestRest:
            return nearestRests.count
        case .expectedTime:
            return expectTimeRests.count
        case .newRest:
            return newRests.count
        case .discount, .moreRest, .searchAndSee:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: collectionView.tag)!
        switch section {
        case .recommendFood:
            guard let recommendFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? RecommendCollectionViewCell else {
                return .init()
            }

            if recommendFood.count > indexPath.item {
                recommendFoodCell.recommendFood = recommendFood[indexPath.item]
                recommendFoodCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                print("recommend \(recommendFoodCell.bugerLabel)")

                guard let imageURL = URL(string: recommendFood[indexPath.item].foodImageURL) else {
                    return .init()
                }
                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (downloadImage, _) in
                    recommendFoodCell.image.image = downloadImage
                }
            }
            return recommendFoodCell
        case .nearestRest:
            guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? NearestCollectionViewCell else {
                return .init()
            }

            if newRests.count > indexPath.item {
                nearestRestCell.nearestRest = nearestRests[indexPath.item]
                print("nearest \(nearestRestCell.name)")
                nearestRestCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                guard let imageURL = URL(string: nearestRests[indexPath.item].mainImage) else {
                    return .init()
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak self] (downloadImage, _) in
                    nearestRestCell.mainImage.image = downloadImage
                }
            }

            return nearestRestCell
        case .expectedTime:
            guard let exepectTimeRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? ExpectTimeCollectionViewCell else {
                return .init()
            }
            if expectTimeRests.count > indexPath.item {
                exepectTimeRestCell.expectTimeRest = expectTimeRests[indexPath.item]
                exepectTimeRestCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                guard let imageURL = URL(string: expectTimeRests[indexPath.item].mainImage) else {
                    return .init()
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak self] (image, _) in
                    exepectTimeRestCell.mainImage.image = image
                }
            }
            return exepectTimeRestCell
        case .newRest:
            guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? NewRestCollectionViewCell else {
                return .init()
            }
            if newRests.count > indexPath.item {
                newRestCell.newRest = newRests[indexPath.item]
                newRestCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                guard let imageURL = URL(string: newRests[indexPath.item].mainImage) else {
                    return .init()
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (downloadImage, _) in
                    newRestCell.mainImage.image = downloadImage
                }
            }
            return newRestCell
        default:
            return .init()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let storboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let collectionViewController = storboard.instantiateViewController(withIdentifier: "CollectionViewController") as? StoreCollectionViewController else {
            return
        }

        let section = Section(rawValue: collectionView.tag)!

        switch section {
        case .recommendFood:
            collectionViewController.passingData(status: SelectState.food(foodId: recommendFood[indexPath.item].id, storeId: recommendFood[indexPath.item].storeId))
        case .nearestRest:
            collectionViewController.passingData(status: SelectState.store(nearestRests[indexPath.item].id))
        default:
            break
        }
        print("selected collectionview tag \(collectionView.tag)")

        self.navigationController?.pushViewController(collectionViewController, animated: true)
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: collectionView.tag) else {
            preconditionFailure("")
        }
        switch section {
        case .recommendFood:
            guard let recommendFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? RecommendCollectionViewCell else {
                return .init()
            }

            var cellHeight: CGFloat = 0
            recommendFoodCell.recommendFood = recommendFood[indexPath.item]

            if recommendFoodCell.recommendFood?.foodDescription == "" {
                recommendFoodCell.commentLabel.isHidden = true
                cellHeight = 260
            } else {
                recommendFoodCell.commentLabel.isHidden = false
                cellHeight = 280.46875
            }

            return .init(width: view.frame.width * 0.8, height: cellHeight)
        case .nearestRest:
            guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? NearestCollectionViewCell else {
                return .init()
            }

            nearestRestCell.nearestRest = nearestRests[indexPath.item]

            var cellHeight: CGFloat = 0
            if nearestRests[indexPath.item].promotion == "" {
                nearestRestCell.promotion.isHidden = true
                cellHeight = 260
            } else {
                nearestRestCell.promotion.isHidden = false
                cellHeight = 280.46875
            }
            return .init(width: view.frame.width * 0.8, height: cellHeight)
        case .expectedTime:
            guard let expectTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? ExpectTimeCollectionViewCell else {
                return .init()
            }
            expectTimeCell.expectTimeRest = expectTimeRests[indexPath.item]

            var cellHeight: CGFloat = 0
            if expectTimeRests[indexPath.item].promotion == "" {
                expectTimeCell.promotion.isHidden = true
                cellHeight = 260
            } else {
                expectTimeCell.promotion.isHidden = false
                cellHeight = 280.46875
            }
            return .init(width: view.frame.width * 0.8, height: cellHeight)
        case .newRest:
            guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? NewRestCollectionViewCell else {
                return .init()
            }

            newRestCell.newRest = newRests[indexPath.item]

            var cellHeight: CGFloat = 0
            if newRests[indexPath.item].promotion == "" {
                newRestCell.promotion.isHidden = true
                cellHeight = 260
            } else {
                newRestCell.promotion.isHidden = false
                cellHeight = 280.46875
            }
            return .init(width: view.frame.width * 0.8, height: cellHeight)
        case .discount:
            return .init(width: 0, height: 0)
        default:
            return .init(width: 400, height: 400)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(rawValue: collectionView.tag)!
        return section.getEdgeInset
    }

}

extension UICollectionViewCell {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 2
    }
}
