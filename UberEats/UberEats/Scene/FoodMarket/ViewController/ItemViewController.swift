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

    // MARK: - Data
    private var foodMarketService: FoodMarketService = DependencyContainer.share.getDependency(key: .foodMarketService)

    private var recommendFood: [Food] = [] {
        didSet {
            for food in recommendFood {
                guard let imageURL = URL(string: food.foodImageURL) else {
                    return
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (_, error) in
                    if error != nil {
                        return
                    }
                }
            }
        }
    }

    private var bannerImagesURL: [String] = [] {
        didSet {
            for bannerImageURL in bannerImagesURL {
                let imageURL = URL(string: bannerImageURL)!

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (_, error) in
                    if error != nil {
                        return
                    }
                }
            }
        }
    }

    private var nearestRests: [Store] = [] {
        didSet {
            for nearestRest in nearestRests {
                let imageURL = URL(string: nearestRest.mainImage)!

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (_, error) in
                    if error != nil {
                        return
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationAuthority()

        initFoodMarket()
        setupTableView()
        setupScrollView()

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
        foodMarketService.requestFoodMarket { [weak self] (dataResponse) in
            if dataResponse.isSuccess {

                guard let recommendFood = dataResponse.value?.recommendFood else {
                    return
                }

//                guard let nearestRest = dataResponse.value?.nearestRest else {
//                    return
//                }

                guard let bannerImagesURL = dataResponse.value?.bannerImages else {
                    return
                }

                self?.recommendFood = recommendFood
//                self?.nearestRests = nearestRest
                self?.bannerImagesURL = bannerImagesURL

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
        let tableNIB = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(tableNIB, forCellReuseIdentifier: "TableViewCellId")
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellId",
                                                            for: indexPath) as? TableViewCell else {
                                                                return .init()
        }

        tablecell.selectionStyle = .none
        tablecell.collectionView.tag = indexPath.section
        tablecell.collectionView.showsHorizontalScrollIndicator = false
        tablecell.collectionView.backgroundColor = .lightGray

        return tablecell
    }

    func setupCollectionViewCell(indexPath: IndexPath, nibName: String, tablecell: TableViewCell) {
        let NIB = UINib(nibName: nibName, bundle: nil)
        let heightOfCollectionViewCell: CGFloat = 0.8333

        tablecell.addSubview(tablecell.collectionView)
        tablecell.collectionView.register(NIB, forCellWithReuseIdentifier: nibName + "Id")

        tablecell.collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        tablecell.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)

        tablecell.setLabel(indexPath.section)
        tablecell.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                tablecell.collectionView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor),
                tablecell.collectionView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor),
                tablecell.collectionView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor),
                tablecell.collectionView.topAnchor.constraint(equalTo: tablecell.recommendLabel.bottomAnchor)
//                tablecell.collectionView.heightAnchor.constraint(equalTo: tablecell.heightAnchor, multiplier: heightOfCollectionViewCell)
            ]
        )

        tablecell.collectionView.delegate = self
        tablecell.collectionView.dataSource = self
        tablecell.collectionView.reloadData()
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
        case .recommendFood, .newRest, .expectedTime, .nearestRest:
            let tableCell = setupTableViewCell(indexPath: indexPath)
            setupCollectionViewCell(indexPath: indexPath, nibName: section.nibName, tablecell: tableCell)
            tableCell.collectionView.reloadData()
            return tableCell
        case .discount:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            tablecell.collectionView.removeFromSuperview()
        case .moreRest:
            if indexPath.row != 0 {
                let seeMoreRestTableViewCellNIB = UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)
                tableView.register(seeMoreRestTableViewCellNIB, forCellReuseIdentifier: section.identifier)
                guard let tablecellOfsixCell = tableView.dequeueReusableCell(
                    withIdentifier: "SeeMoreRestTableViewCellId",
                    for: indexPath) as? SeeMoreRestTableViewCell else {
                        return .init()
                }
                tablecellOfsixCell.selectionStyle = .none
                return tablecellOfsixCell
            } else {
                return .init()
            }
        case .searchAndSee:
            let tablecell = setupTableViewCell(indexPath: indexPath)

            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            tablecell.collectionView.removeFromSuperview()
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
                return section.heightOfTableViewCell(view.frame.height)
            }
        default:
            return section.heightOfTableViewCell(view.frame.height)
        }

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter
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
            return 6
        case .newRest:
            return 4
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
            recommendFoodCell.recommendFood = recommendFood[indexPath.item]
            recommendFoodCell.dropShadow(color: .gray, offSet: CGSize(width: 0, height: 0))
            return recommendFoodCell
        case .nearestRest:
            guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as? NearestCollectionViewCell else {
                return .init()
            }
            nearestRestCell.nearestRest = nearestRests[indexPath.item]
            return nearestRestCell
        case .expectedTime, .newRest:
            return collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath)
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

            print("123123")
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
            return .init(width: view.frame.width * 0.8, height: view.frame.width * 0.8)
        case .nearestRest, .expectedTime, .newRest :
            return .init(width: view.frame.width * 0.8, height: view.frame.width * 0.8 * 0.82)
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
