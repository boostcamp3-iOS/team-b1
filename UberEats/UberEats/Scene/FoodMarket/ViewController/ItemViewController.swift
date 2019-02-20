//
//  ItemViewController.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit
import Service
import DependencyContainer
import ServiceInterface
import Common

class ItemViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private var lastDragginCollecionviewTag = 0

    // MARK: - ScrollView
    @IBOutlet var scrollView: UIScrollView!

     lazy var indicator: SplashIndicatorView = {
        let view = SplashIndicatorView()
        view.frame = self.view.frame
        view.center = self.view.center
        view.isHidden = true
        return view
    }()

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
         return self.view.frame.height * 0.25
    }()

    private lazy var widthOfPageControl: CGFloat = {
       return self.view.frame.width - 280
    }()

    private let leftPaddingOfPageControl: CGFloat = 30

    private let heightOfPageControl: CGFloat = 37

    private lazy var heightOfFooter: CGFloat = {
        return self.view.frame.height * (10 / 812)
    }()

    private static let bannerTimeInterval: TimeInterval = 4

    private static let numberOfSection = 8

    private lazy var widthOfCollectionViewCell: CGFloat = {
        return self.view.frame.width * 0.8
    }()

    private let RecommendCollectionViewCellNIB = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
    private let ExpectTimeCollectionViewCellNIB = UINib(nibName: "ExpectTimeCollectionViewCell", bundle: nil)
    private let NewRestCollectionViewCellNIB = UINib(nibName: "NewRestCollectionViewCell", bundle: nil)
    private let NearestCollectionViewCellNIB = UINib(nibName: "NearestCollectionViewCell", bundle: nil)
    private let SeeMoreRestTableViewCellNIB = UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)

    private let tableNIB = UINib(nibName: "TableViewCell", bundle: nil)

    private let collectionViewHeaderFooterReuseIdentifier = "FoodRestMoreFooterViewCellId"
    private let nearestCollectionViewCellId = "NearestCollectionViewCellId"
    private let expectTimeCollectionViewCellId = "ExpectTimeCollectionViewCellId"
    private let newRestCollectionViewCellId = "NewRestCollectionViewCellId"

    private let tableViewCellId = "TableViewCellId"

    private lazy var dataIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = self.view.frame
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        indicator.backgroundColor = .white
        return indicator
    }()

    // MARK: - Data
    private var foodMarketService: FoodMarketService = DependencyContainer.share.getDependency(key: .foodMarketService)

    private var recommendFoodTableCell: RecomendTableCell?

    private var expectTimeRestsTableCell: TableViewCell?
    private var newRestsTableCell: TableViewCell?
    private var nearestRestsTableCell: TableViewCell?

    private var discountTableViewCell = DiscountTableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize.init()))
    private var searchAndSeeTableViewCell = SearchAndSeeTableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize.init()))

    private var restaurtSeeMoreCollectionViewCell: RestaurtSeeMoreCollectionViewCell?

    //reuseCell 때문에 스크롤이 동시에 움직이는 현상. --> reuse 셀을 쓰지 않고 셀을 만들고 그것을 계속 씀
    private var recommendFood: [Food] = [] {
        didSet {
            recommendFoodTableCell = RecomendTableCell(frame: CGRect(origin: CGPoint.zero, size: CGSize.init()))

            recommendFoodTableCell?.collectionView.delegate = self
            recommendFoodTableCell?.collectionView.dataSource = self

            recommendFoodTableCell?.collectionView.isHidden = false
            recommendFoodTableCell?.collectionView.reloadData()
        }
    }

    private var nearestRests: [Store] = [] {
        didSet {
            expectTimeRestsTableCell = setupDataInCollectionView(row: 0, section: 2)
        }
    }

    private var expectTimeRests: [Store] = [] {
        didSet {
            newRestsTableCell = setupDataInCollectionView(row: 0, section: 3)
        }
    }

    private var newRests: [Store] = [] {
        didSet {
             nearestRestsTableCell = setupDataInCollectionView(row: 0, section: 4)
        }
    }

    private var bannerImagesURL: [String] = [] {
        didSet {
            setupScrollView()
        }
    }

    private var moreRests: [Store] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initFoodMarket()

        setupTableView()

        isScrolledByUser = false

        bannerTimer = Timer.scheduledTimer(timeInterval: ItemViewController.bannerTimeInterval, target: self,
                                           selector: #selector(autoScrolledBanner), userInfo: nil, repeats: true)

        restaurtSeeMoreCollectionViewCell = RestaurtSeeMoreCollectionViewCell()

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func touchUpSettingLocation(_ sender: Any) {
        present(SettingLocationViewController(), animated: true, completion: nil)
    }

    private func setupDataInCollectionView(row: Int, section: Int) -> TableViewCell {
        let indexPath = IndexPath(row: row, section: section)
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                            for: indexPath) as? TableViewCell else {
                                                                return .init()
        }
        return tablecell
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

                guard let moreRests = dataResponse.value?.moreRests else {
                    return
                }

                self?.nearestRests = nearestRest
                self?.bannerImagesURL = bannerImagesURL
                self?.expectTimeRests = exepectTimeRests
                self?.recommendFood = recommendFood
                self?.newRests = newRests
                self?.moreRests = moreRests

            } else {
                fatalError()
            }

            self?.tableView.reloadData()
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false

        self.tabBarController?.view.addSubview(indicator)
        tableView.addSubview(pageControl)
        tableView.bringSubviewToFront(pageControl)

        tableView.register(tableNIB, forCellReuseIdentifier: tableViewCellId)
        tableView.register(SeeMoreRestTableViewCellNIB, forCellReuseIdentifier: "SeeMoreRestTableViewCellId")
    }

    @objc func autoScrolledBanner() {
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
        let frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        let changedPageNumber = pageControl.currentPage
        scrollView.frame.origin = CGPoint(x: frame.size.width * CGFloat(changedPageNumber), y: 0)
        scrollView.scrollRectToVisible(scrollView.frame, animated: true)
    }

}

// MARK: - ScrollViewDelegate
extension ItemViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            bannerTimer.invalidate()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollView {
            bannerTimer = Timer.scheduledTimer(timeInterval: 4, target: self,
                                               selector: #selector(autoScrolledBanner), userInfo: nil, repeats: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = pageIndex
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != self.scrollView && scrollView != self.tableView {
                let pageWidth: Float = Float(view.frame.width * 0.8) + 10//width+spacing

                let currentOffset: Float = Float(scrollView.contentOffset.x)

                let targetOffset: Float = Float(targetContentOffset.pointee.x)

                var newTargetOffset: Float = 0

                newTargetOffset = targetOffset > currentOffset ?
                    ceilf(currentOffset / pageWidth) * pageWidth :
                    floorf(currentOffset / pageWidth) * pageWidth

                if newTargetOffset < 0 {
                    newTargetOffset = 0
                } else if (newTargetOffset > Float(scrollView.contentSize.width)) {
                    newTargetOffset = Float(Float(scrollView.contentSize.width))
                }
                targetContentOffset.pointee.x = CGFloat(currentOffset)
                scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        }
    }
}

// MARK: - TabelViewDelegate
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 && indexPath.row != 0 {
            let storboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let collectionViewController = storboard.instantiateViewController(withIdentifier: "CollectionViewController") as? StoreCollectionViewController else {
                return
            }

            collectionViewController.passingData(status: SelectState.store(moreRests[indexPath.row - 1].id))

            navigationController?.pushViewController(collectionViewController, animated: true)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemViewController.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //enum의 연관값 사용!
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .bannerScroll, .recommendFood, .nearestRest, .expectedTime, .newRest, .discount, .searchAndSee:
            return section.numberOfSection
        case .moreRest:
            return moreRests.count
        }
    }

    func setupTableViewCell(indexPath: IndexPath) -> TableViewCell {
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                            for: indexPath) as? TableViewCell else {
                                                                return .init()
        }

        tablecell.collectionView.tag = indexPath.section

        return tablecell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let tableviewSection = Section(rawValue: indexPath.section) else {
            return .init()
        }
        switch tableviewSection {
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
            guard let tableCell = recommendFoodTableCell else {
                return .init()
            }
            return tableCell
        case .expectedTime:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.collectionView.register(ExpectTimeCollectionViewCellNIB, forCellWithReuseIdentifier: expectTimeCollectionViewCellId)
            tablecell.collectionView.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: "colelctionVIewMoreRestCellId")

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            tablecell.collectionView.isHidden = false
            return tablecell
        case .newRest:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }

            tablecell.collectionView.tag = indexPath.section
            tablecell.collectionView.register(NewRestCollectionViewCellNIB, forCellWithReuseIdentifier: newRestCollectionViewCellId)
            tablecell.collectionView.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: "colelctionVIewMoreRestCellId")

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell
        case .nearestRest:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                                for: indexPath) as? TableViewCell else {
                                                                    return .init()
            }
            tablecell.collectionView.tag = indexPath.section
            tablecell.collectionView.register(NearestCollectionViewCellNIB, forCellWithReuseIdentifier: nearestCollectionViewCellId)
            tablecell.collectionView.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: "colelctionVIewMoreRestCellId")

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            tablecell.collectionView.isHidden = false
            return tablecell
        case .discount:
            return discountTableViewCell
        case .moreRest:
            if indexPath.row == 0 {
                return MoreRestTitleTableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize.init()))
            } else {
                guard let moreRestTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "SeeMoreRestTableViewCellId",
                    for: indexPath) as? SeeMoreRestTableViewCell else {
                        return .init()
                }

                if moreRests.count > indexPath.row {
                    moreRestTableViewCell.moreRests = moreRests[indexPath.row]

                    guard let imageURL = URL(string: moreRests[indexPath.item].mainImage) else {
                        return moreRestTableViewCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (downloadImage, _) in
                        moreRestTableViewCell.mainImage.image = downloadImage
                    }
                }
                return moreRestTableViewCell
            }
        case .searchAndSee:
            return searchAndSeeTableViewCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .moreRest:
            if indexPath.row == 0 {
                return 50
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
}

// MARK: - CollectionViewDelegate
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let sections = Section(rawValue: collectionView.tag)!
        switch sections {
        case .bannerScroll:
            return 0
        case .recommendFood:
            if section == 0 {
                return recommendFood.count
            } else {
                return 1
            }
        case .nearestRest:
            if section == 0 {
                return nearestRests.count
            } else {
                return 1
            }
        case .expectedTime:
            if section == 0 {
                return expectTimeRests.count
            } else {
                return 1
            }
        case .newRest:
            if section == 0 {
                return newRests.count
            } else {
                return 1
            }
        case .discount, .moreRest, .searchAndSee:
            return 0
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = Section(rawValue: collectionView.tag)!
        switch sections {
        case .bannerScroll:
            return 0
        case .recommendFood, .nearestRest, .expectedTime, .newRest:
           return 2
        case .discount, .moreRest, .searchAndSee:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let collectionViewTag = Section(rawValue: collectionView.tag) else {
            return .init()
        }

        switch collectionViewTag {
        case .recommendFood:
            guard let recommendTableViewCell = recommendFoodTableCell else {
                return .init()
            }

            if indexPath.section == 0 {
                guard let recommendCollectionViewCell = recommendTableViewCell.collectionView.dequeueReusableCell(withReuseIdentifier: recommendTableViewCell.collectionVIewCellId, for: indexPath) as? RecommendCollectionViewCell else {
                    return .init()
                }

                if recommendFood.count > indexPath.item {
                    recommendCollectionViewCell.recommendFood = recommendFood[indexPath.item]
                    recommendCollectionViewCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                    guard let imageURL = URL(string: recommendFood[indexPath.item].foodImageURL) else {
                        return recommendCollectionViewCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (downloadImage, _) in
                        recommendCollectionViewCell.image.image = downloadImage
                    }
                }
                return recommendCollectionViewCell
            } else { //더보기 등록
                guard let recommendCollectionViewCell = recommendTableViewCell.collectionView.dequeueReusableCell(withReuseIdentifier: recommendTableViewCell.colelctionVIewMoreRestCellId, for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }
                return recommendCollectionViewCell
            }
        case .nearestRest:
            if indexPath.section == 0 {
                guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: nearestCollectionViewCellId, for: indexPath) as? NearestCollectionViewCell else {
                    return .init()
                }

                if newRests.count > indexPath.item {
                    nearestRestCell.nearestRest = nearestRests[indexPath.item]

                    nearestRestCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                    guard let imageURL = URL(string: nearestRests[indexPath.item].mainImage) else {
                        return nearestRestCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (downloadImage, _) in
                        nearestRestCell.mainImage.image = downloadImage
                    }
                }

                return nearestRestCell
            } else {
                guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colelctionVIewMoreRestCellId", for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }
                return nearestRestCell
            }
        case .expectedTime:
            if indexPath.section == 0 {
                guard let exepectTimeRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: expectTimeCollectionViewCellId, for: indexPath) as? ExpectTimeCollectionViewCell else {
                    return .init()
                }

                if expectTimeRests.count > indexPath.item {
                    exepectTimeRestCell.expectTimeRest = expectTimeRests[indexPath.item]
                    exepectTimeRestCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                    guard let imageURL = URL(string: expectTimeRests[indexPath.item].mainImage) else {
                        return exepectTimeRestCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (image, _) in
                        exepectTimeRestCell.mainImage.image = image
                    }
                }
                return exepectTimeRestCell
            } else {
                guard let exepectTimeRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colelctionVIewMoreRestCellId", for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }
                return exepectTimeRestCell
            }

        case .newRest:
            if indexPath.section == 0 {
                guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: newRestCollectionViewCellId, for: indexPath) as? NewRestCollectionViewCell else {
                    return .init()
                }
                if newRests.count > indexPath.item {
                    newRestCell.newRest = newRests[indexPath.item]
                    newRestCell.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: -1), radius: 5.0, scale: true)

                    guard let imageURL = URL(string: newRests[indexPath.item].mainImage) else {
                        return newRestCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (downloadImage, _) in
                        newRestCell.mainImage.image = downloadImage
                    }
                }
                return newRestCell
            } else {
                guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colelctionVIewMoreRestCellId", for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }
                return newRestCell
            }
        case .searchAndSee, .discount, .bannerScroll, .moreRest:
            return .init()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let storboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let storeViewController = storboard.instantiateViewController(withIdentifier: "CollectionViewController")
            as? StoreCollectionViewController else {
            return
        }

        guard let collectionViewTag = Section(rawValue: collectionView.tag) else {
            return
        }

        if indexPath.section == 0 {

            switch collectionViewTag {
            case .recommendFood:
                collectionViewController.passingData(status: SelectState.food(foodId: recommendFood[indexPath.item].id, storeId: recommendFood[indexPath.item].storeId))
            case .nearestRest:
                collectionViewController.passingData(status: SelectState.store(nearestRests[indexPath.item].id))
            case .expectedTime:
                collectionViewController.passingData(status: SelectState.store(expectTimeRests[indexPath.item].id))
            case .newRest:
                collectionViewController.passingData(status: SelectState.store(newRests[indexPath.item].id))
            default:
                break
            }
            self.navigationController?.pushViewController(collectionViewController, animated: true)
        } else {
            let SeeMoreRestVC = SeeMoreRestViewController()
            SeeMoreRestVC.section = collectionViewTag
            self.navigationController?.pushViewController(SeeMoreRestVC, animated: true)
        }

    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let collectionViewTag = Section(rawValue: collectionView.tag) else {
            preconditionFailure("")
        }

        switch collectionViewTag {
        case .recommendFood:
            if indexPath.section == 0 {
                guard let recommendFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewTag.identifier, for: indexPath) as? RecommendCollectionViewCell else {
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

                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: 100, height: 100)
            }
        case .nearestRest:
            if indexPath.section == 0 {
                guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewTag.identifier, for: indexPath) as? NearestCollectionViewCell else {
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

                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: 100, height: 100)
            }
        case .expectedTime:
            if indexPath.section == 0 {
                guard let expectTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewTag.identifier, for: indexPath) as? ExpectTimeCollectionViewCell else {
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
                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: 100, height: 100)
            }
        case .newRest:
            if indexPath.section == 0 {
                guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewTag.identifier, for: indexPath) as? NewRestCollectionViewCell else {
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
                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: 100, height: 100)
            }
        case .discount:
            return .init()
        case .moreRest:
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
