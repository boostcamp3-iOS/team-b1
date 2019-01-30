//
//  ItemViewController.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

// swiftlint:disable all
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

    private let numberOfSection = 8

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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: - tableview cell init
        let recommendTable = UINib(nibName: "RecommendTableViewCell", bundle: nil)
        tableView.register(recommendTable, forCellReuseIdentifier: "RecommendTableViewCellId")

        let SeeMoreRestTableViewCellNIB = UINib(nibName: "SeeMoreRestTableViewCell", bundle: nil)
        tableView.register(SeeMoreRestTableViewCellNIB, forCellReuseIdentifier: "SeeMoreRestTableViewCellId")
        
        //tableview의 섹션별로 collectionview를 관리한다.
        switch indexPath.section {
        case 0 :
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            scrollView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: tablecell.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor).isActive = true
            
            tablecell.backgroundColor = .green
            tableView.backgroundColor = .green
        case 1:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            let recommendNIB = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
            tablecell.addSubview(tablecell.collectionView)
            tablecell.collectionView.register(recommendNIB, forCellWithReuseIdentifier: "RecommendCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            
            tablecell.recommendLabel.text = "추천 요리"
        
            tablecell.collectionView.translatesAutoresizingMaskIntoConstraints = false
            tablecell.collectionView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor).isActive = true
            tablecell.collectionView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor).isActive = true
            tablecell.collectionView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor).isActive = true
            tablecell.collectionView.heightAnchor.constraint(equalTo: tablecell.heightAnchor, multiplier: 0.833).isActive = true
            //tablecell.collectionView.backgroundColor = .blue
        
            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            
            return tablecell
        case 2:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            let nearestNIB = UINib(nibName: "NearestCollectionViewCell", bundle: nil)
            tablecell.addSubview(tablecell.collectionView)
            tablecell.collectionView.register(nearestNIB, forCellWithReuseIdentifier: "NearestCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.recommendLabel.text = "가까운 인기 레스토랑"
            
            tablecell.collectionView.translatesAutoresizingMaskIntoConstraints = false
            tablecell.collectionView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor).isActive = true
            tablecell.collectionView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor).isActive = true
            tablecell.collectionView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor).isActive = true
            tablecell.collectionView.heightAnchor.constraint(equalTo: tablecell.heightAnchor, multiplier: 0.833).isActive = true

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()

            return tablecell
        case 3:
            
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            let expaecteNIB = UINib(nibName: "ExpectTimeCollectionViewCell", bundle: nil)
            tablecell.addSubview(tablecell.collectionView)
            tablecell.collectionView.register(expaecteNIB, forCellWithReuseIdentifier: "ExpectTimeCollectionViewCellId")
            
            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            
            tablecell.recommendLabel.text = "예상 시간 30분 이하"
            
            tablecell.collectionView.translatesAutoresizingMaskIntoConstraints = false
            tablecell.collectionView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor).isActive = true
            tablecell.collectionView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor).isActive = true
            tablecell.collectionView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor).isActive = true
            tablecell.collectionView.heightAnchor.constraint(equalTo: tablecell.heightAnchor, multiplier: 0.833).isActive = true

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 4:
            
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            let newRestNIB = UINib(nibName: "NewRestCollectionViewCell", bundle: nil)
            tablecell.addSubview(tablecell.collectionView)
            tablecell.collectionView.register(newRestNIB, forCellWithReuseIdentifier: "NewRestCollectionViewCellId")

            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            
            tablecell.recommendLabel.text = "새로운 레스토랑"
            
            tablecell.collectionView.translatesAutoresizingMaskIntoConstraints = false
            tablecell.collectionView.bottomAnchor.constraint(equalTo: tablecell.bottomAnchor).isActive = true
            tablecell.collectionView.leadingAnchor.constraint(equalTo: tablecell.leadingAnchor).isActive = true
            tablecell.collectionView.trailingAnchor.constraint(equalTo: tablecell.trailingAnchor).isActive = true
            tablecell.collectionView.heightAnchor.constraint(equalTo: tablecell.heightAnchor, multiplier: 0.833).isActive = true

            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 5://주문시 5천원 할인
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            tablecell.collectionView.removeFromSuperview()
        case 6://tableCell인데 레스토랑 더보기 tableCell을 만든다.
            if indexPath.row != 0 {
                guard let tablecellOfsixCell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreRestTableViewCellId", for: indexPath) as? SeeMoreRestTableViewCell else {
                    return .init()
                }
                tablecellOfsixCell.selectionStyle = .none
                return tablecellOfsixCell
            }else {
                return .init()
            }
        case 7:
            guard let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as? RecommendTableViewCell else {
                return .init()
            }
            tablecell.selectionStyle = .none
            tablecell.collectionView.tag = indexPath.section
            
            tablecell.recommendLabel.text = "주문시 5천원 할인 받기"
            tablecell.collectionView.removeFromSuperview()
            return tablecell
        default:
            print("default")
        }
        return .init()
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return view.frame.height * (10/812)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return view.frame.height * 0.44
        }else if indexPath.section == 2 {
            return view.frame.height * 0.5
        }else if indexPath.section == 3 {
            return view.frame.height * 0.5
        }else if indexPath.section == 4 {
            return view.frame.height * 0.5
        }else if indexPath.section == 5 {
            return view.frame.height * 0.14
        }else if indexPath.section == 6 {
            if indexPath.row == 0 {
                return 80
            }else {
                return view.frame.height * 0.5
            }
        }else if indexPath.section == 7 {
            return view.frame.height * 0.2
        }
    
        return 200
        
//        return UIDevice.current.screenType.tableCellSize(for: Section.init(rawValue: indexPath.row) ?? Section.recommendFood.rawValue)
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
            return 0
        case 6://레스토랑 더보기
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
        if collectionView.tag == 1 {
            return CGSize(width: tableView.frame.width * 0.6, height: tableView.frame.width * 0.61 * 0.92)
        }else if collectionView.tag == 2 {
            return CGSize(width: tableView.frame.width * 0.76, height: tableView.frame.width * 0.76 * 0.868)
        }else if collectionView.tag == 3 {
            return CGSize(width: tableView.frame.width * 0.76, height: tableView.frame.width * 0.76 * 0.868)
        }else if collectionView.tag == 4 {
            return CGSize(width: tableView.frame.width * 0.76, height: tableView.frame.width * 0.76 * 0.868)
        }else if collectionView.tag == 5 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 400 , height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1://추천요리
            return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        case 2://가까운 인기 레스토랑
            return UIEdgeInsets(top: 30, left: 24, bottom: 24, right: 30)
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
