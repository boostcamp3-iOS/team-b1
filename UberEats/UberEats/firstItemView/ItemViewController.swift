//  ItemViewController.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var tableView: UITableView!

    @IBOutlet var scrollView: UIScrollView!
    private var images: [String] = ["1_1", "2_1", "3_1", "4_1", "5_1", "6_1"]
    private var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var labelString: [String] = ["추천요리", "가까운 인기 레스토랑", "예상 시간 30분 이하", "Uber Eats 신규 레스토랑", "주문시 5천원 할인 받기", "가나다라", "마바사", "아자차카", "타파하", "아아아앙아", "집에", "가고", "싶다"]
    private var gameTimer: Timer!
    private var collectionViewItems: [Int] = []

    private var images: [String] = ["1_1", "2_1", "3_1", "4_1", "5_1", "6_1"]

    private var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

    private var labelString: [String] = ["추천요리", "가까운 인기 레스토랑", "예상 시간 30분 이하", "Uber Eats 신규 레스토랑",
                                         "주문시 5천원 할인 받기", "가나다라", "마바사", "아자차카", "타파하", "아아아앙아", "집에", "가고", "싶다"]
    private var gameTimer: Timer!

    private var collectionViewItems: [Int] = []

    private var bannerImages: [String] = ["1_1", "2_1", "3_1", "4_1", "5_1", "6_1"]

    private var bannerTimer: Timer!

    private var isScrolledByUser: Bool!

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 50, y: scrollView.frame.height - 40,
                                                      width: scrollView.frame.width - 280, height: 37))
        pageControl.currentPage = 0
        return pageControl
    }()

    private static let numberOfSection = 8

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupScrollView()

        pageControl.currentPage = 0
        isScrolledByUser = false

        bannerTimer = Timer.scheduledTimer(timeInterval: 4, target: self,
                                           selector: #selector(scrolledBanner), userInfo: nil, repeats: true)
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(pageControl)
        tableView.bringSubviewToFront(pageControl)
    }

    @objc func scrolledBanner() {
        /* guard로 false 처리
         guard isAutoScrollMode else {
         return
         }
         */
        let nextPage = pageControl.currentPage + 1

        let point = nextPage >= bannerImages.count ?
            CGPoint(x: 0, y: 0) :
            CGPoint(x: view.frame.width * CGFloat(nextPage), y: 0)

        scrollView.setContentOffset(point, animated: true)
    }

    func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false

        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<bannerImages.count {
            frame.origin.x = view.frame.width * CGFloat(index)
            frame.size = scrollView.frame.size

            let bannerImage = UIImageView(frame: frame)
            bannerImage.image = UIImage(named: bannerImages[index])

            scrollView.addSubview(bannerImage)
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(bannerImages.count),
                                        height: scrollView.frame.height)
        scrollView.delegate = self

        pageControl.numberOfPages = bannerImages.count
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }

    @objc func pageChanged() {
        let pageNumber = pageControl.currentPage
        var frame = scrollView.frame

        frame.origin.x = frame.size.width * CGFloat(pageNumber)
        frame.origin.y = 0

        scrollView.scrollRectToVisible(frame, animated: true)
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
            //수정
            if scrollView.contentOffset.x >= view.frame.width * CGFloat(bannerImages.count - 1) {
                scrollView.isScrollEnabled = false
                scrollView.isScrollEnabled = true
            }

            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(page)
        }
    }
}

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    // 섹션 7개
    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemViewController.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        switch section {
        case .bannerScroll:
            return 0
        case .recommendFood, .nearestRest, .expectedTime, .newRest, .discount, .searchAndSee:
            return 1
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

        return tablecell
    }

    func setupCollectionViewCell(indexPath: IndexPath, nibName: String, tablecell: TableViewCell) {
        let NIB = UINib(nibName: nibName, bundle: nil)
        tablecell.addSubview(tablecell.collectionView)
        tablecell.collectionView.register(NIB, forCellWithReuseIdentifier: nibName + "Id")

        tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255,
                                                           blue: 247 / 255, alpha: 1.0)

        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .recommendFood:
            tablecell.recommendLabel.text = "추천 요리"
        case .nearestRest:
            tablecell.recommendLabel.text = "가까운 인기 레스토랑"
        case .expectedTime:
            tablecell.recommendLabel.text = "예상 시간 30분 이하"
        case .newRest:
            tablecell.recommendLabel.text = "새로운 레스토랑"
        default:
            tablecell.recommendLabel.text = ""
        }

        tablecell.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                tablecell.collectionView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor),
                tablecell.collectionView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor),
                tablecell.collectionView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor),
                tablecell.collectionView.heightAnchor.constraint(equalTo: tablecell.heightAnchor, multiplier: 0.833)
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
        case .recommendFood:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            setupCollectionViewCell(indexPath: indexPath, nibName: "RecommendCollectionViewCell", tablecell: tablecell)
            return tablecell
        case .nearestRest:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            setupCollectionViewCell(indexPath: indexPath, nibName: "NearestCollectionViewCell", tablecell: tablecell)
            return tablecell
        case .expectedTime:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            setupCollectionViewCell(indexPath: indexPath, nibName: "ExpectTimeCollectionViewCell", tablecell: tablecell)
            return tablecell
        case .newRest:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            setupCollectionViewCell(indexPath: indexPath, nibName: "NewRestCollectionViewCell", tablecell: tablecell)
            return tablecell
        case .discount:
            let tablecell = setupTableViewCell(indexPath: indexPath)
            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            tablecell.collectionView.removeFromSuperview()
        case .moreRest:
            if indexPath.row != 0 {
                let seeMoreRestTableViewCellNIB = UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)
                tableView.register(seeMoreRestTableViewCellNIB, forCellReuseIdentifier: "SeeMoreRestTableViewCellId")
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
        case .recommendFood:
            return view.frame.height * 0.44
        case .nearestRest, .expectedTime, .newRest:
            return view.frame.height * 0.5
        case .discount:
            return view.frame.height * 0.14
        case .moreRest:
            if indexPath.row == 0 {
                return 80
            } else {
                return view.frame.height * 0.5
            }
        case .searchAndSee:
            return view.frame.height * 0.2
        case .bannerScroll:
            return 0
        }
        // MARK: - 디바이스별 분기 나눠서 오토레이아웃 적용 방법 예시
        //return UIDevice.current.screenType.tableCellSize(for: Section.init(rawValue: indexPath.row)

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return view.frame.height * (10/812)
    }
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let section = Section(rawValue: collectionView.tag)!
        switch section {
        case .bannerScroll:
            return 0
        case .recommendFood:
            return 7
        case .nearestRest:
            return 6
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

        collectionView.showsHorizontalScrollIndicator = false

        let section = Section(rawValue: collectionView.tag)!
        switch section {
        case .bannerScroll:
            collectionView.backgroundColor = .lightGray
        case .recommendFood://추천요리
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionViewCellId",
                                            for: indexPath) as? RecommendCollectionViewCell else { return .init()}
            cell.layer.cornerRadius = 5
            return cell
        case .nearestRest://가까운 인기 레스토랑
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearestCollectionViewCellId",
                                            for: indexPath) as? NearestCollectionViewCell else {return .init()}
            cell.layer.cornerRadius = 5
            return cell
        case .expectedTime://예상 시간
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpectTimeCollectionViewCellId",
                                            for: indexPath) as? ExpectTimeCollectionViewCell else {return .init()}
            cell.backgroundColor = .lightGray
            return cell
        case .newRest://신규 레스토랑
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRestCollectionViewCellId",
                                            for: indexPath) as? NewRestCollectionViewCell else {return .init()}
            cell.backgroundColor = .lightGray
            return cell
        default:
            return .init()
        }
        return .init()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storboard = UIStoryboard.init(name: "Main", bundle: nil)
        let collectionViewController = storboard.instantiateViewController(withIdentifier: "CollectionViewController")
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
            return CGSize(width: tableView.frame.width * 0.6, height: tableView.frame.width * 0.61 * 0.92)
        case .nearestRest, .expectedTime, .newRest :
            return CGSize(width: tableView.frame.width * 0.76, height: tableView.frame.width * 0.76 * 0.868)
        case .discount:
            return CGSize(width: 0, height: 0)
        default:
            return CGSize(width: 400, height: 400)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case 0:
            return UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30)
        case 1://추천요리
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 2://가까운 인기 레스토랑
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        case 3://예상 시간
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        case 4://신규 레스토랑
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        //case 5: 주문시 5천원 할인받기
        default:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(rawValue: collectionView.tag)!
        switch section {
        case .bannerScroll:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .recommendFood:
            return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        case .nearestRest:
            return UIEdgeInsets(top: 30, left: 24, bottom: 24, right: 30)
        case .expectedTime:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        case .newRest:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        default:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        }
    }
}
