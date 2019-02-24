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

    @IBOutlet weak var tableView: UITableView!

    // MARK: - ScrollView
    @IBOutlet weak var scrollView: UIScrollView!

     lazy var indicator: SplashIndicatorView = {
        let view = SplashIndicatorView()
        view.frame = self.view.frame
        view.center = self.view.center
        return view
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: UIDevice.current.pageControlX,
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
         return 176
    }()

    private lazy var widthOfPageControl: CGFloat = {
       return self.view.frame.width - 280
    }()

    private let leftPaddingOfPageControl: CGFloat = 20

    private let heightOfPageControl: CGFloat = 37

    private lazy var heightOfFooter: CGFloat = {
        return self.view.frame.height * (10 / 812)
    }()

    private static let bannerTimeInterval: TimeInterval = 4

    private static let numberOfSection = 8

    private lazy var widthOfCollectionViewCell: CGFloat = {
        return self.view.frame.width * 0.8
    }()

    private let mustSelectSection = 6
    private let mustNotSelectRow = 0

    private let moreSeeCellWidth = 100
    private let moreSeeCellHeight = 100

    private let moreSeeData = 1

    private let heightOfMoreRestTitle: CGFloat = 50

    private let restMoreSeeTableViewRow = 0

    private let tableViewCellId = "TableViewCellId"

    private let collectionViewDataSection = 0

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

    private var recommendFoodStaticTableCell = RecomendTableCell(frame: CGRect(origin: CGPoint.zero,
                                                                               size: CGSize.init()))

    private var restaurtSeeMoreCollectionViewCell = RestaurtSeeMoreCollectionViewCell()

    private var deliveryCompleteStaticTableCell = DeliveryCompleteStaticTableCell()

    private var recommendFood: [FoodForView] = [] {
        didSet {
            recommendFoodStaticTableCell.collectionView.delegate = self
            recommendFoodStaticTableCell.collectionView.dataSource = self

            recommendFoodStaticTableCell.collectionView.reloadData()
        }
    }

    private var nearestRests: [StoreForView] = [] {
        didSet {
            //필요 없을거 같은데 없으면 collectionviewcell이 나타나지 않음
            _ = setupDataInCollectionView(row: 0, section: 2)
        }
    }

    private var expectTimeRests: [StoreForView] = [] {
        didSet {
            _ = setupDataInCollectionView(row: 0, section: 3)
        }
    }

    private var newRests: [StoreForView] = [] {
        didSet {
             _ = setupDataInCollectionView(row: 0, section: 4)
        }
    }

    private var bannerImagesURL: [String] = [] {
        didSet {
            _ = setupScrollView()
        }
    }

    private var moreRests: [StoreForView] = []

    private var completeState: (state: Bool, storeName: String, storeImageURL: String)?

    override func viewDidLoad() {
        super.viewDidLoad()

        completeState = (state: true, storeName: "", storeImageURL: "")

        tabBarController?.view.addSubview(indicator)

        initFoodMarket()

        setupTableView()

        isScrolledByUser = false

        bannerTimer = .scheduledTimer(timeInterval: ItemViewController.bannerTimeInterval,
                                      target: self,
                                      selector: #selector(autoScrolledBanner),
                                      userInfo: nil,
                                      repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    @IBAction func touchUpSettingLocation(_ sender: Any) {
        present(SettingLocationViewController(), animated: true, completion: nil)
    }

    private func setupDataInCollectionView(row: Int, section: Int) -> TableViewCell {
        let indexPath = IndexPath(row: row, section: section)
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                            for: indexPath)
                                                            as? TableViewCell else {
                return .init()
        }
        return tablecell
    }

    private func initFoodMarket() {
        foodMarketService.requestFoodMarket(dispatchQueue: DispatchQueue.global()) { [weak self] (dataResponse) in

            guard dataResponse.isSuccess,
                let recommendFood = dataResponse.value?.recommendFood,
                let nearestRest = dataResponse.value?.nearestRest,
                let bannerImagesURL = dataResponse.value?.bannerImages,
                let exepectTimeRests = dataResponse.value?.expectTimeRest,
                let newRests = dataResponse.value?.newRests,
                let moreRests = dataResponse.value?.moreRests else {
                    return
            }

            self?.nearestRests = nearestRest
            self?.bannerImagesURL = bannerImagesURL
            self?.expectTimeRests = exepectTimeRests
            self?.recommendFood = recommendFood
            self?.newRests = newRests
            self?.moreRests = moreRests

            self?.tableView.reloadData()
            //self?.indicator.isHidden = true
            self?.indicator.removeFromSuperview()
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false

        tableView.addSubview(pageControl)
        tableView.bringSubviewToFront(pageControl)

        tableView.register(UINib.TableViewCellNIB, forCellReuseIdentifier: tableViewCellId)
        tableView.register(UINib.SeeMoreRestTableViewCellNIB, forCellReuseIdentifier: "SeeMoreRestTableViewCellId")
    }

    @objc func autoScrolledBanner() {
        let nextPageOfPageControl: Int = pageControl.currentPage + 1

        let point = nextPageOfPageControl >= bannerImagesURL.count ?
            CGPoint.zero :
            CGPoint(x: view.frame.width * CGFloat(nextPageOfPageControl), y: 0)

        scrollView.setContentOffset(point, animated: true)
    }

    private func addBannerImageView() {
        var frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)

        for index in 0..<bannerImagesURL.count {
            frame.origin.x = view.frame.width * CGFloat(index)
            frame.size = scrollView.frame.size

            let bannerImage = UIImageView(frame: frame)

            guard let imageURL = URL(string: bannerImagesURL[index]) else {
                return
            }

            ImageNetworkManager.shared.getImageByCache(imageURL: imageURL,
                                                       complection: { [weak bannerImage] (downloadImage, _) in
                bannerImage?.image = downloadImage
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
            bannerTimer = .scheduledTimer(timeInterval: 4,
                                          target: self,
                                          selector: #selector(autoScrolledBanner),
                                          userInfo: nil,
                                          repeats: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = pageIndex
        }
    }

    //FIXME: - 우버잇츠 처럼 자연스러운 드래깅
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView != self.scrollView && scrollView != self.tableView {

                let pageWidth: Float = Float(widthOfCollectionViewCell) + 15//width+spacing

                let currentOffset: Float = Float(scrollView.contentOffset.x)

                let targetOffset: Float = Float(targetContentOffset.pointee.x)

                var newTargetOffset: Float = 0

                newTargetOffset = targetOffset > currentOffset ?
                    ceilf(currentOffset / pageWidth) * pageWidth :
                    floorf(currentOffset / pageWidth) * pageWidth

                if newTargetOffset < 0 {
                    newTargetOffset = 0
                } else if (newTargetOffset > Float(scrollView.contentSize.width)) {
                    newTargetOffset = Float(Float(scrollView.contentSize.width - 200))
                }

                targetContentOffset.pointee.x = CGFloat(currentOffset)

                scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        }
    }
}

// MARK: - TabelViewDelegate
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == mustSelectSection && indexPath.row != mustNotSelectRow {
            guard let collectionViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "CollectionViewController")
                as? StoreCollectionViewController else {
                return
            }

            collectionViewController.passingData(status: SelectState.store(moreRests[indexPath.row].id))

            tabBarController?.tabBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.pushViewController(collectionViewController, animated: true)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemViewController.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //enum의 연관값 사용!
        guard let tableViewSection = TableViewSection(rawValue: section) else {
            return 0
        }

        switch tableViewSection {
        case .bannerScroll:
            guard let completeState = completeState else {
                return 0
            }
            if completeState.state {
                return 1
            } else {
                return tableViewSection.numberOfSection
            }
        case .recommendFood, .nearestRest, .expectedTime, .newRest, .discount, .searchAndSee:
            return tableViewSection.numberOfSection
        case .moreRest:
            return moreRests.count
        }

    }

    func setupTableViewCell(indexPath: IndexPath) -> TableViewCell {
        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId,
                                                            for: indexPath)
            as? TableViewCell else {
            return .init()
        }

        tablecell.collectionView.tag = indexPath.section

        return tablecell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let tableviewSection = TableViewSection(rawValue: indexPath.section) else {
            return .init()
        }
        switch tableviewSection {
        case .bannerScroll:
            deliveryCompleteStaticTableCell.storeInfo = (state: true, storeName: "hihi", storeImageURL: "gogossing")
            return deliveryCompleteStaticTableCell
        case .recommendFood:
            return recommendFoodStaticTableCell
        case .expectedTime:
            let tablecell = setupTableViewCell(indexPath: indexPath)

            tablecell.collectionView.register(UINib.ExpectTimeCollectionViewCellNIB, forCellWithReuseIdentifier: tableviewSection.identifier)

            tablecell.collectionView.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: tableviewSection.moreRestCellId)

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell
        case .newRest:
            let tablecell = setupTableViewCell(indexPath: indexPath)

            tablecell.collectionView.register(UINib.NewRestCollectionViewCellNIB, forCellWithReuseIdentifier: tableviewSection.identifier)

            tablecell.collectionView.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: tableviewSection.moreRestCellId)

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell

        case .nearestRest:
            let tablecell = setupTableViewCell(indexPath: indexPath)

            tablecell.collectionView.register(UINib.NearestCollectionViewCellNIB, forCellWithReuseIdentifier: tableviewSection.identifier)
            tablecell.collectionView.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: tableviewSection.moreRestCellId)

            tablecell.setLabel(indexPath.section)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self

            return tablecell
        case .discount:
            return DiscountTableViewCell(frame: CGRect(origin: CGPoint.zero,
                                                       size: CGSize.init()))
        case .moreRest:
            if indexPath.row == restMoreSeeTableViewRow {
                return MoreRestTitleTableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize.init()))
            } else {
                guard let moreRestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreRestTableViewCellId",
                                                                                for: indexPath)
                                                                                as? SeeMoreRestTableViewCell else {
                    return .init()
                }

                if moreRests.count > indexPath.row {

                    moreRestTableViewCell.moreRests = moreRests[indexPath.row]

                    guard let imageURL = URL(string: moreRests[indexPath.item].mainImage) else {
                        return moreRestTableViewCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak moreRestTableViewCell] (downloadImage, error) in
                        if error != nil {
                            return
                        }
                        guard moreRestTableViewCell?.moreRests?.mainImage == imageURL.absoluteString else {
                            return
                        }
                        moreRestTableViewCell?.mainImage.image = downloadImage
                    }

                }
                return moreRestTableViewCell
            }
        case .searchAndSee:
            return SearchAndSeeTableViewCell(frame: CGRect(origin: CGPoint.zero,
                                                           size: CGSize.init()))
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableViewSection = TableViewSection(rawValue: indexPath.section) else {
            return 0
        }

        switch tableViewSection {
        case .moreRest:
            if indexPath.row == restMoreSeeTableViewRow {
                return heightOfMoreRestTitle
            } else {
                return tableViewSection.heightOfTableViewCell()
            }

        default:
            return tableViewSection.heightOfTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter
    }

}

// MARK: - CollectionViewDelegate
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let tableViewSection = TableViewSection(rawValue: collectionView.tag) else {
            return 0
        }

        if section == collectionViewDataSection {
            switch tableViewSection {
            case .recommendFood:
                return recommendFood.count
            case .nearestRest:
                return nearestRests.count
            case .expectedTime:
                return expectTimeRests.count
            case .newRest:
                return newRests.count
            default:
                return 0
            }
        } else {
            switch tableViewSection {
            case .nearestRest, .expectedTime, .newRest:
                return moreSeeData
            default:
                return 0
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let talbeViewSection = TableViewSection(rawValue: collectionView.tag) else {
            return 0
        }

        return talbeViewSection.numberOfCollectionViewSection
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let tableViewSection = TableViewSection(rawValue: collectionView.tag) else {
            return .init()
        }

        switch tableViewSection {
        case .recommendFood:
                guard let recommendCollectionViewCell = recommendFoodStaticTableCell.collectionView.dequeueReusableCell(withReuseIdentifier: recommendFoodStaticTableCell.collectionVIewCellId, for: indexPath) as? RecommendCollectionViewCell else {
                    return .init()
                }

                if recommendFood.count > indexPath.item {
                    recommendCollectionViewCell.recommendFood = recommendFood[indexPath.item]
                    recommendCollectionViewCell.dropShadow(color: .gray,
                                                           opacity: 0.2,
                                                           offSet: CGSize(width: 1, height: -1),
                                                           radius: 5.0,
                                                           scale: true)

                    guard let imageURL = URL(string: recommendFood[indexPath.item].foodImageURL) else {
                        return recommendCollectionViewCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak recommendCollectionViewCell] (downloadImage, _) in
                        guard recommendCollectionViewCell?.confirmURL?.absoluteString == imageURL.absoluteString else {return }
                        recommendCollectionViewCell?.image.image = downloadImage
                    }
                }

                return recommendCollectionViewCell
        case .nearestRest:
            if indexPath.section == collectionViewDataSection {
                guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? NearestCollectionViewCell else {
                    return .init()
                }

                if newRests.count > indexPath.item {
                    nearestRestCell.nearestRest = nearestRests[indexPath.item]

                    nearestRestCell.dropShadow(color: .gray,
                                               opacity: 0.2,
                                               offSet: CGSize(width: 1, height: -1),
                                               radius: 5.0,
                                               scale: true)

                    guard let imageURL = URL(string: nearestRests[indexPath.item].mainImage) else {
                        return nearestRestCell
                    }

                    //weak nearestRestCell 한것에 주의!
                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak nearestRestCell] (downloadImage, _) in
                        guard nearestRestCell?.confirmURL?.absoluteString == imageURL.absoluteString else {return }
                        nearestRestCell?.mainImage.image = downloadImage
                    }
                }

                return nearestRestCell
            } else {
                guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.moreRestCellId, for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }
                return nearestRestCell
            }
        case .expectedTime:
            if indexPath.section == collectionViewDataSection {
                guard let exepectTimeRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? ExpectTimeCollectionViewCell else {
                    return .init()
                }

                if expectTimeRests.count > indexPath.item {
                    exepectTimeRestCell.expectTimeRest = expectTimeRests[indexPath.item]
                    exepectTimeRestCell.dropShadow(color: .gray,
                                                   opacity: 0.2,
                                                   offSet: CGSize(width: 1, height: -1),
                                                   radius: 5.0,
                                                   scale: true)

                    guard let imageURL = URL(string: expectTimeRests[indexPath.item].mainImage) else {
                        return exepectTimeRestCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) {[weak exepectTimeRestCell] (image, _) in
                        guard exepectTimeRestCell?.confirmURL?.absoluteString == imageURL.absoluteString else {return }
                        exepectTimeRestCell?.mainImage.image = image
                    }
                }
                return exepectTimeRestCell
            } else {
                guard let exepectTimeRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.moreRestCellId, for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }
                return exepectTimeRestCell
            }

        case .newRest:
            if indexPath.section == collectionViewDataSection {
                guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? NewRestCollectionViewCell else {
                    return .init()
                }

                if newRests.count > indexPath.item {
                    newRestCell.newRest = newRests[indexPath.item]
                    newRestCell.dropShadow(color: .gray,
                                           opacity: 0.2,
                                           offSet: CGSize(width: 1, height: -1),
                                           radius: 5.0,
                                           scale: true)

                    guard let imageURL = URL(string: newRests[indexPath.item].mainImage) else {
                        return newRestCell
                    }

                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) {[weak newRestCell] (downloadImage, _) in
                        guard newRestCell?.confirmURL?.absoluteString == imageURL.absoluteString else {return }
                        newRestCell?.mainImage.image = downloadImage
                    }
                }
                return newRestCell
            } else {
                guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.moreRestCellId, for: indexPath) as? RestaurtSeeMoreCollectionViewCell else {
                    return .init()
                }

                return newRestCell
            }
        case .searchAndSee, .discount, .bannerScroll, .moreRest:
            return .init()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let storeViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "CollectionViewController")
            as? StoreCollectionViewController else {
            return
        }

        guard let tableViewSection = TableViewSection(rawValue: collectionView.tag) else {
            return
        }

        if indexPath.section == collectionViewDataSection {
            switch tableViewSection {
            case .recommendFood:
                storeViewController.passingData(status: SelectState.food(foodId: recommendFood[indexPath.item].id,
                                                                         storeId: recommendFood[indexPath.item].storeId))
            case .nearestRest:
                storeViewController.passingData(status: SelectState.store(nearestRests[indexPath.item].id))
            case .expectedTime:
                storeViewController.passingData(status: SelectState.store(expectTimeRests[indexPath.item].id))
            case .newRest:
                storeViewController.passingData(status: SelectState.store(newRests[indexPath.item].id))
            default:
                break
            }

            tabBarController?.tabBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.pushViewController(storeViewController, animated: true)
        } else {
            let SeeMoreRestVC = SeeMoreRestViewController()
            SeeMoreRestVC.section = tableViewSection

            tabBarController?.tabBar.isHidden = false
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(SeeMoreRestVC, animated: true)
        }

    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let tableViewSection = TableViewSection(rawValue: collectionView.tag) else {
            preconditionFailure("")
        }

        switch tableViewSection {
        case .recommendFood:

                guard let recommendFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? RecommendCollectionViewCell else {
                    return .init()
                }

                recommendFoodCell.recommendFood = recommendFood[indexPath.item]

                let cellHeight = recommendFoodCell.isExistFoodDescription()

                return .init(width: widthOfCollectionViewCell, height: cellHeight)

        case .nearestRest:
            if indexPath.section == collectionViewDataSection {
                guard let nearestRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? NearestCollectionViewCell else {
                    return .init()
                }
                nearestRestCell.nearestRest = nearestRests[indexPath.item]

                let cellHeight = nearestRestCell.isExistPromotion()

                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: moreSeeCellWidth, height: moreSeeCellHeight)
            }
        case .expectedTime:
            if indexPath.section == collectionViewDataSection {
                guard let expectTimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? ExpectTimeCollectionViewCell else {
                    return .init()
                }
                expectTimeCell.expectTimeRest = expectTimeRests[indexPath.item]

                let cellHeight = expectTimeCell.isExistPromotion()

                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: moreSeeCellWidth, height: moreSeeCellHeight)
            }
        case .newRest:
            if indexPath.section == collectionViewDataSection {
                guard let newRestCell = collectionView.dequeueReusableCell(withReuseIdentifier: tableViewSection.identifier, for: indexPath) as? NewRestCollectionViewCell else {
                    return .init()
                }
                newRestCell.newRest = newRests[indexPath.item]

                let cellHeight = newRestCell.isExistPromotion()

                return .init(width: widthOfCollectionViewCell, height: cellHeight)
            } else {
                return .init(width: moreSeeCellWidth, height: moreSeeCellHeight)
            }
        default:
            return .init()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let tableViewSection = TableViewSection(rawValue: collectionView.tag) else {
            return .init()
        }
        return tableViewSection.getEdgeInset
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

extension UINib {
    static var TableViewCellNIB: UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }

    static var SeeMoreRestTableViewCellNIB: UINib {
        return UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)
    }

    static var ExpectTimeCollectionViewCellNIB: UINib {
        return UINib(nibName: "ExpectTimeCollectionViewCell", bundle: nil)
    }

    static var NewRestCollectionViewCellNIB: UINib {
        return UINib(nibName: "NewRestCollectionViewCell", bundle: nil)
    }

    static var NearestCollectionViewCellNIB: UINib {
        return UINib(nibName: "NearestCollectionViewCell", bundle: nil)
    }
}
