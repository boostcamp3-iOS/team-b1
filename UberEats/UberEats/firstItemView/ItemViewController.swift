//
//  ItemViewController.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UIScrollViewDelegate {
    let headerId = "headerId"
    //    @IBOutlet var scrollView: UIScrollView!
    //    @IBOutlet var tableView: UITableView!
    //    @IBOutlet var stPageControl: UIPageControl!
    
    @IBOutlet var tableView: UITableView!
    //@IBOutlet var stPageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    
    var images: [String] = ["1_1", "2_1", "3_1","4_1","5_1","6_1"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var labelString: [String] = ["추천요리","가까운 인기 레스토랑","예상 시간 30분 이하","Uber Eats 신규 레스토랑","주문시 5천원 할인 받기", "가나다라", "마바사", "아자차카", "타파하", "아아아앙아", "집에", "가고", "싶다"]
    
    //자동으로 scrollivew 움직이도록
    var gameTimer: Timer!
    
    var collectionViewItems:[Int] = []
    
    lazy var stPageControl: UIPageControl = {
        let pc = UIPageControl(frame: CGRect(x: 50, y: scrollView.frame.height - 40, width: scrollView.frame.width - 280, height: 37))
        //pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        collectionViewItems = [1,10,10,10,10,1,1,1]
        setupLayout()
        setupScrollView()
        
        tableView.addSubview(stPageControl)
        tableView.bringSubviewToFront(stPageControl)
        
        stPageControl.currentPage = 0
        
        //view.addSubview(pageControl)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func setupLayout() {
        //        tableView.register(MainTableHeaderView.self, forCellReuseIdentifier: headerId)
    }
    
    @objc func runTimedCode() {
        //print("4초마다 실행 되길 ...")
        let nextPage = stPageControl.currentPage + 1
        if nextPage >= images.count {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else {
            self.scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(nextPage), y: 0), animated: true)
        }
    }
    
    func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        for index in 0..<images.count {
            frame.origin.x = view.frame.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        scrollView.delegate = self
        
        stPageControl.numberOfPages = images.count
        stPageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
    }
    
    @objc func pageChanged() {
        let pageNumber = stPageControl.currentPage
        var frame = scrollView.frame
        
        frame.origin.x = frame.size.width * CGFloat(pageNumber)
        frame.origin.y = 0
        
        scrollView.scrollRectToVisible(frame, animated: true) //?
    }
    
    //스크롤 시작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //remove timer from Roop
        gameTimer.invalidate()
    }
    //스크롤 끝
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        gameTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollView {
            if scrollView.contentOffset.x <= -1 {
                scrollView.isScrollEnabled = false
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                scrollView.isScrollEnabled = true
            }
            
            if scrollView.contentOffset.x >= view.frame.width * CGFloat(images.count - 1) {
                scrollView.isScrollEnabled = false
                scrollView.isScrollEnabled = true
            }
            
            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            stPageControl.currentPage = Int(page)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //        var page = scrollView.contentOffset.x / scrollView.frame.size.width
        //        //        print("scrollView.contentOffset.x \(scrollView.contentOffset.x)")
        //        //        print("scrollView.frame.size.width \(scrollView.frame.size.width)")
        //        //        print("page \(page)")
        //        var currentEndPoint = scrollView.contentOffset.x
        //
        //        stPageControl.currentPage = Int(page)
        
    }
}

//MARK:- tableview
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    // 섹션 7개
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 1
        case 6:
            return 10
        case 7:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
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
        
        let RecommendTableViewCellNIB = UINib(nibName: "RecommendTableViewCell", bundle: nil)
        tableView.register(RecommendTableViewCellNIB, forCellReuseIdentifier: "RecommendTableViewCellId")
        
        let tablecell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCellId", for: indexPath) as! RecommendTableViewCell
        
        tablecell.selectionStyle = .none
        
        tablecell.collectionView.tag = indexPath.section
        
        //tableview의 섹션별로 collectionview를 관리한다.
        switch tablecell.collectionView.tag {
        case 1:
            let RecommendCollectionViewCellNIB = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(RecommendCollectionViewCellNIB, forCellWithReuseIdentifier: "RecommendCollectionViewCellId")
            
            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            
            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 2:
            let NearestCollectionViewCellNIB = UINib(nibName: "NearestCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(NearestCollectionViewCellNIB, forCellWithReuseIdentifier: "NearestCollectionViewCellId")
            
            
            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            
            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 3:
            let NearestCollectionViewCellNIB = UINib(nibName: "ExpectTimeCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(NearestCollectionViewCellNIB, forCellWithReuseIdentifier: "ExpectTimeCollectionViewCellId")
            
            
            tablecell.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            tablecell.collectionView.backgroundColor = UIColor(displayP3Red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
            
            tablecell.collectionView.delegate = self
            tablecell.collectionView.dataSource = self
            tablecell.collectionView.reloadData()
            return tablecell
        case 4:
            let NewRestCollectionViewCellNIB = UINib(nibName: "NewRestCollectionViewCell", bundle: nil)
            tablecell.collectionView.register(NewRestCollectionViewCellNIB, forCellWithReuseIdentifier: "NewRestCollectionViewCellId")
            
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
        //
        return tablecell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1://추천요리
            return 231
        case 2://가까운 인기 레스토랑
            return 240
        case 3://예상 시간 30분 이하 레스토랑
            return 260
        case 4://Uber Eats 신규 레스토랑
            return 260
        case 5://주문시 5천원 할인
            return 70
        case 6:
            return 130
        case 7:
            return 70
        default:
            return 70
        }
    }
}

//MARK:- Collectionview
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
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionViewCellId", for: indexPath) as! RecommendCollectionViewCell
            cell2.layer.cornerRadius = 5
            return cell2
        case 2://가까운 인기 레스토랑
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "NearestCollectionViewCellId", for: indexPath) as! NearestCollectionViewCell
            cell2.layer.cornerRadius = 5
            return cell2
        case 3://예상 시간
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpectTimeCollectionViewCellId", for: indexPath) as! ExpectTimeCollectionViewCell
            cell2.backgroundColor = .lightGray
            return cell2
        case 4://신규 레스토랑
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRestCollectionViewCellId", for: indexPath) as! NewRestCollectionViewCell
            cell2.backgroundColor = .lightGray
            return cell2
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionViewCellId", for: indexPath)
                as! RecommendCollectionViewCell
            cell.backgroundColor = .lightGray
            return cell
        }
        
        let cell = UICollectionViewCell()
        return cell
    }
}

//MARK:- UICollectionViewFlowLayout
extension ItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            print("0")
        case 1://추천요리
            return CGSize(width: 223, height: 231)
        case 2://가까운 인기 레스토랑
            return CGSize(width: 170, height: 240)
        case 3://예상 시간 30분 이하 레스토랑
            return CGSize(width: 200, height: 231)
        case 4://신규 레스토랑
            return CGSize(width: 170, height: 170)
        //case 5: 주문시 5천원 할인 받기
        default:
            return CGSize(width: 180, height: 180)
        }
        return CGSize(width: 180, height: 180)
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
}
