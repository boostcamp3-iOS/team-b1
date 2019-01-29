//
//  ItemViewController.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UIScrollViewDelegate {
    private static let headerId = "headerId"

    @IBOutlet var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    
    private var images: [String] = ["1_1", "2_1", "3_1","4_1","5_1","6_1"]
    private var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var labelString: [String] = ["추천요리","가까운 인기 레스토랑","예상 시간 30분 이하","Uber Eats 신규 레스토랑","주문시 5천원 할인 받기", "가나다라", "마바사", "아자차카", "타파하", "아아아앙아", "집에", "가고", "싶다"]
    private var gameTimer: Timer!
    private var collectionViewItems:[Int] = []
    
    private var bannerImages: [String] = ["1_1", "2_1", "3_1","4_1","5_1","6_1"]
    private var bannerTimer: Timer!
    private var isScrolledByUser: Bool!

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl(frame: CGRect(x: 50, y: scrollView.frame.height - 40, width: scrollView.frame.width - 280, height: 37))
        pc.currentPage = 0
        return pc
    }()

    private let numberOfSection = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupScrollView()

        pageControl.currentPage = 0
        isScrolledByUser = false

        bannerTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrolledBanner), userInfo: nil, repeats: true)
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(pageControl)
        tableView.bringSubviewToFront(pageControl)
    }

    @objc func scrolledBanner() {
        //print("4초마다 실행 되길 ...")

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

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(bannerImages.count), height: scrollView.frame.height)
        scrollView.delegate = self

        pageControl.numberOfPages = bannerImages.count
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }

    @objc func pageChanged() {
        let pageNumber = pageControl.currentPage
        var frame = scrollView.frame

        frame.origin.x = frame.size.width * CGFloat(pageNumber)
        frame.origin.y = 0

        scrollView.scrollRectToVisible(frame, animated: true) //?
    }

    //스크롤 시작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //remove timer from Roop
        bannerTimer.invalidate()

        // isScrolledByUser = true
        //ㅇ
    }
    //스크롤 끝
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        bannerTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrolledBanner), userInfo: nil, repeats: true)

        //isScrolledByUser = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == self.scrollView {
            //수정하기
            if scrollView.contentOffset.x >= view.frame.width * CGFloat(bannerImages.count - 1) {
                scrollView.isScrollEnabled = false
                scrollView.isScrollEnabled = true
            }

            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(page)
        }
    }
}


// MARK: - tableview
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
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
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            let headerView = UIView()
            headerView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)

            let headerLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()

            headerView.addSubview(headerLabel)

            NSLayoutConstraint.activate([
                headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
                ])

            headerLabel.text = labelString[section - 1]

            return headerView
        }
    }

    // 셀 만드는 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let recommendTable = UINib(nibName: "RecommendTableViewCell", bundle: nil)
        tableView.register(recommendTable, forCellReuseIdentifier: "RecommendTableViewCellId")

        guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {return .init()}

        tablecell.selectionStyle = .none
        tablecell.collectionView.tag = indexPath.section

        //tableview의 섹션별로 collectionview를 관리한다.
        switch tablecell.collectionView.tag {
        case 0 :
            scrollView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: tablecell.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor).isActive = true
            
            tablecell.backgroundColor = .green
            tableView.backgroundColor = .green

        case 1:
            let recommendNIB = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(recommendNIB, forCellWithReuseIdentifier: "RecommendCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()

            //tableView.backgroundColor = .green
            return tablecell
        case 2:
            let nearestNIB = UINib(nibName: "NearestCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(nearestNIB, forCellWithReuseIdentifier: "NearestCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 3:
            let expaecteNIB = UINib(nibName: "ExpectTimeCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(expaecteNIB, forCellWithReuseIdentifier: "ExpectTimeCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 4:
            let newRestNIB = UINib(nibName: "NewRestCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(newRestNIB, forCellWithReuseIdentifier: "NewRestCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 5://주문시 5천원 할인
            if indexPath.row == 0 {
                tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            }
        default:
            print("default")
        }
        return tablecell
    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
//        return UIDevice.current.screenType.tableCellSize(for: Section.init(rawValue: indexPath.row) ?? Section.recommendFood.rawValue)
//        switch indexPath.section {
//        case 0:
//            return
//        case 1://추천요리
//            return 231
//        case 2://가까운 인기 레스토랑
//            return 240
//        case 3://예상 시간 30분 이하 레스토랑
//            return 260
//        case 4://Uber Eats 신규 레스토랑
//            return 260
//        case 5://주문시 5천원 할인
//            return 70
//        case 6:
//            return 130
//        case 7:
//            return 70
//        default:
//            return 70
//        }
    }
}

// MARK: - Collectionview
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch collectionView.tag {
        case 0:
            return 0
        case 1://UberEatas 신규 레스토랑
            return 7
        case 2://가까운 인기 레스토랑
            return 6
        case 3://예상 시간,추천요리
            return 6
        case 4://신규 레스토랑 , 추천요리
            return 4
        case 5://주문시 5천원 할인
            collectionView.backgroundColor = .green
            return 0
        case 6://레스토랑 더보기
            collectionView.backgroundColor = .black
            return 0
        case 7://찾아보기나 검색하기
            collectionView.backgroundColor = .yellow
            return 0
        default:
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.showsHorizontalScrollIndicator = false

        switch collectionView.tag {
        case 0:
            collectionView.backgroundColor = .lightGray
        case 1://추천요리
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionViewCellId", for: indexPath) as? RecommendCollectionViewCell else {return .init()}
            cell2.layer.cornerRadius = 5
            return cell2
        case 2://가까운 인기 레스토랑
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "NearestCollectionViewCellId", for: indexPath) as? NearestCollectionViewCell else {return .init()}
            cell2.layer.cornerRadius = 5
            return cell2
        case 3://예상 시간
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpectTimeCollectionViewCellId", for: indexPath) as? ExpectTimeCollectionViewCell else {return .init()}
            cell2.backgroundColor = .lightGray
            return cell2
        case 4://신규 레스토랑
            guard let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRestCollectionViewCellId", for: indexPath) as? NewRestCollectionViewCell else {return .init()}
            cell2.backgroundColor = .lightGray
            return cell2
        default:
            return .init()
        }
        let cell = UICollectionViewCell()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storboard = UIStoryboard.init(name: "Main", bundle: nil)
        let collectionViewController = storboard.instantiateViewController(withIdentifier: "CollectionViewController")
        self.navigationController?.pushViewController(collectionViewController, animated: true)
    }
}
// MARK: - UICollectionViewFlowLayout
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: collectionView.tag)
            else { preconditionFailure("") }
        return CGSize(width: 200, height: 200)
        //return UIDevice.current.screenType.collectionCellSize(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1://추천요리
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
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
}


/*
extension UIDevice.ScreenType {
    func collectionCellSize(for section: Section) -> CGSize {
        switch (self, section) {
        case (.iPhones_4_4S, .bannerScroll):
            return CGSize(width: 100, height: 200)
        case (.iPhones_4_4S, .recommendFood):
            return CGSize(width: 100, height: 200)
        case (.iPhones_4_4S, .nearestRest):
            return CGSize(width: 100, height: 200)
        case (.iPhones_4_4S, .expectedTime):
            return CGSize(width: 100, height: 200)
        
        case (.iPhones_5_5s_5c_SE, .bannerScroll):
            return CGSize(width: 100, height: 250)
        case (.iPhones_5_5s_5c_SE, .recommendFood):
            return CGSize(width: 221, height: 200)
        case (.iPhones_5_5s_5c_SE, .nearestRest):
            return CGSize(width: 221, height: 250)
        case (.iPhones_5_5s_5c_SE, .expectedTime):
            return CGSize(width: 100, height: 250)
            
        case (.iPhones_6_6s_7_8, .bannerScroll):
            return CGSize(width: 100, height: 270)
        case (.iPhones_6_6s_7_8, .recommendFood):
            return CGSize(width: 100, height: 270)
        case (.iPhones_6_6s_7_8, .nearestRest):
            return CGSize(width: 100, height: 270)
        case (.iPhones_6_6s_7_8, .expectedTime):
            return CGSize(width: 100, height: 270)
            
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .bannerScroll):
            return CGSize(width: 100, height: 280)
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .recommendFood):
            return CGSize(width: 100, height: 280)
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .nearestRest):
            return CGSize(width: 100, height: 280)
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .expectedTime):
            return CGSize(width: 100, height: 280)
            
        case (.iPhones_X_XS, .bannerScroll):
            return CGSize(width: 100, height: 300)
        case (.iPhones_X_XS, .recommendFood):
            return CGSize(width: 100, height: 300)
        case (.iPhones_X_XS, .nearestRest):
            return CGSize(width: 100, height: 300)
        case (.iPhones_X_XS, .expectedTime):
            return CGSize(width: 100, height: 300)
            
        case (.iPhone_XR, .bannerScroll):
            return CGSize(width: 100, height: 310)
        case (.iPhone_XR, .recommendFood):
            return CGSize(width: 100, height: 310)
        case (.iPhone_XR, .nearestRest):
            return CGSize(width: 100, height: 310)
        case (.iPhone_XR, .expectedTime):
            return CGSize(width: 100, height: 310)
            
        case (.iPhone_XSMax, .bannerScroll):
            return CGSize(width: 100, height: 310)
        case (.iPhone_XSMax, .recommendFood):
            return CGSize(width: 100, height: 310)
        case (.iPhone_XSMax, .nearestRest):
            return CGSize(width: 100, height: 310)
        case (.iPhone_XSMax, .expectedTime):
            return CGSize(width: 100, height: 310)
            
        default: return CGSize(width: 100, height: 200)
        }
    }
    
    func tableCellSize(for section: Section) -> CGFloat {
        switch (self, section) {
        case (.iPhones_4_4S, .bannerScroll):
            return 200
        case (.iPhones_4_4S, .recommendFood):
            return 300
        case (.iPhones_4_4S, .nearestRest):
            return 400
        case (.iPhones_4_4S, .expectedTime):
            return 500
            
        case (.iPhones_5_5s_5c_SE, .bannerScroll):
            return 200
        case (.iPhones_5_5s_5c_SE, .recommendFood):
            return 300
        case (.iPhones_5_5s_5c_SE, .nearestRest):
            return 400
        case (.iPhones_5_5s_5c_SE, .expectedTime):
            return 500
            
        case (.iPhones_6_6s_7_8, .bannerScroll):
            return 200
        case (.iPhones_6_6s_7_8, .recommendFood):
            return 300
        case (.iPhones_6_6s_7_8, .nearestRest):
            return 400
        case (.iPhones_6_6s_7_8, .expectedTime):
            return 500
            
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .bannerScroll):
            return 200
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .recommendFood):
            return 300
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .nearestRest):
            return 400
        case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .expectedTime):
            return 500
            
        case (.iPhones_X_XS, .bannerScroll):
            return 200
        case (.iPhones_X_XS, .recommendFood):
            return 300
        case (.iPhones_X_XS, .nearestRest):
            return 400
        case (.iPhones_X_XS, .expectedTime):
            return 500
            
        case (.iPhone_XR, .bannerScroll):
            return 200
        case (.iPhone_XR, .recommendFood):
            return 300
        case (.iPhone_XR, .nearestRest):
            return 400
        case (.iPhone_XR, .expectedTime):
            return 500
            
        case (.iPhone_XSMax, .bannerScroll):
            return 200
        case (.iPhone_XSMax, .recommendFood):
            return 300
        case (.iPhone_XSMax, .nearestRest):
            return 400
        case (.iPhone_XSMax, .expectedTime):
            return 500
            
        case (.unknown, _):
            return 200
        case (_, .newRest):
            return 300
        case (_, .discount):
            return 400
        case (_, .moreRest):
            return 400
        case (_, .searchAndSee):
            return 400
        default:
            return 300
        }
    }
}
*/

enum Section: Int {
    case bannerScroll = 0
    case recommendFood = 1
    case nearestRest = 2
    case expectedTime = 3
    case newRest = 4
    case discount = 5
    case moreRest = 6
    case searchAndSee = 7
}
