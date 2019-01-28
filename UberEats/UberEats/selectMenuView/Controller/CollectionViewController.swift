//
//  CollectionViewController.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 21/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//
import UIKit

class CollectionViewController: UICollectionViewController {
    
    let foods: [Food] = [Food.init(foodName: "제육정식 Korean Set with Grilled Pork",
                                   foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                   price: "₩8,900",
                                   foodImage: nil),
                         Food.init(foodName: "부대찌개개개개개ㅐ애애애애애애애 Korean Set with Grilled Pork",
                                   foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                   price: "₩8,900",
                                   foodImage: nil),
                         Food.init(foodName: "햄버거 Korean Set with Grilled Pork",
                                   foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                   price: "₩8,900",
                                   foodImage: nil),
                         Food.init(foodName: "피자 Korean Set with Grilled Pork",
                                   foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                   price: "₩1,000,900",
                                   foodImage: nil),
                         Food.init(foodName: "부대찌개개개개개ㅐ애애애애애애애 Korean Set with Grilled Pork",
                                   foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                   price: "₩8,900",
                                   foodImage: nil)]
    
    var firstHeaderView: HeaderView?
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let tempId = "tempId"
    fileprivate let storeId = "storeId"
    fileprivate let menuId = "menuId"
    fileprivate let smallMenuId = "smallMenuId"
    fileprivate let menuDetailId = "menuDetailId"
    fileprivate let menuSectionId = "menuSectionId"
    
    private let padding: CGFloat = 5
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    private var likeStatus: Bool = false
    
    let searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        return button
    }()
    
    lazy var menuSectionIndexCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        setupCollectionViewLayout()
    }
    
    //MARK:- Method
    
    func setupLayout() {
        collectionView.backgroundColor = .white
        // scrollBar 없애기 위함
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(backButton)
        view.addSubview(likeButton)
        view.addSubview(menuSectionIndexCollectionView)
        
        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(touchUpLikeButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            menuSectionIndexCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            menuSectionIndexCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuSectionIndexCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuSectionIndexCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            
            likeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            likeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 25),
            likeButton.heightAnchor.constraint(equalToConstant: 25)
            ])
    }
    
    func setupCollectionView() {
        // collectionView가 위에 safeArea까지 사용하게 한다.
        // contentInsetAdjustmentBehavior를 never로 하면 scroll view content insets는 절대 조정되지 않는다.
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(TempCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tempId)
        
        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: menuDetailId)
        
        let storeNib = UINib(nibName: "StoreInfoCollectionViewCell", bundle: nil)
        self.collectionView.register(storeNib, forCellWithReuseIdentifier: storeId)
        
        let menuNib = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: menuId)
        
        let smallMenuNib = UINib(nibName: "SmallMenuHeaderView", bundle: nil)
        self.collectionView.register(smallMenuNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: smallMenuId)
        
        menuSectionIndexCollectionView.register(TempCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tempId)
        
        let menuSectionNib = UINib(nibName: "MenuSectionCollectionViewCell", bundle: nil)
        menuSectionIndexCollectionView.register(menuSectionNib, forCellWithReuseIdentifier: menuSectionId)
        
    }
    
    func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? StretchyHeaderLayout {
            layout.itemSizeDelegate = self
            
            // header와 collectionview와의 거리
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            //            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    // Object-C Method
    
    @objc func touchUpBackButton(_: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func touchUpLikeButton(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "like") {
            sender.setImage(#imageLiteral(resourceName: "selectLike"), for: .normal)
            likeStatus = true
        } else {
            sender.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            likeStatus = false
        }
    }
    
    // 상태바 스타일
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    //MARK:- Delegate, DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.menuSectionIndexCollectionView {
            return 1
        } else {
            return 7
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.menuSectionIndexCollectionView {
            return 6
        }
        
        switch section {
        case 0, 1, 2:
            return 1
        case 3, 4, 5, 6:
            return foods.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuSectionIndexCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuSectionId, for: indexPath) as? MenuSectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.sectionName = "나를 위한 메뉴"
            cell.isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
            
            return cell
        }
        
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: storeId, for: indexPath)
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuId, for: indexPath) as? SearchCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.searchBarDelegate = self
            return cell
        case 3, 4, 5, 6:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuDetailId, for: indexPath) as? FoodCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.food = foods[indexPath.item]
            
            return cell
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            if collectionView == self.menuSectionIndexCollectionView {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: tempId, for: indexPath)
                return header
            }
            
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderView else {
                    return UICollectionReusableView()
                }
                
                firstHeaderView = header
                
                return header
            case 3, 4, 5, 6:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: smallMenuId, for: indexPath) as? SmallMenuHeaderView else {
                    return UICollectionReusableView()
                }
                
                header.menuLabel.text = "나를 위한 추천 메뉴"
                
                return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: tempId, for: indexPath)
                return header
            }
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: tempId, for: indexPath)
    }
    
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.menuSectionIndexCollectionView {
            return CGSize(width: 20, height: 80)
        }
        
        switch section {
        case 0:
            return CGSize(width: self.view.frame.width, height: 280)
        case 1:
            return CGSize(width: self.view.frame.width, height: 1)
        case 3, 4, 5, 6:
            return CGSize(width: self.view.frame.width, height: 70)
        default:
            return CGSize(width: self.view.frame.width, height: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuSectionIndexCollectionView {
            // 선택한 section목록으로 이동시키는 부분
            let indx = IndexPath(item: 0, section: indexPath.row + 3)
            self.collectionView.selectItem(at: indx, animated: true, scrollPosition: .top)
        } else {
            let storyboard = UIStoryboard.init(name: "FoodItemDetails", bundle: nil)
            let FoodItemVC = storyboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")
            
            //self.present(FoodItemVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(FoodItemVC, animated: true)
        }
    }
    
    //MARK:- ScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.menuSectionIndexCollectionView {
            if scrollView.contentOffset.y > 320 {
                self.likeButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
                self.collectionView.contentInset = UIEdgeInsets(top: 235, left: 0, bottom: 0, right: 0)
            } else {
                if likeStatus == true {
                    self.likeButton.setImage(#imageLiteral(resourceName: "selectLike"), for: .normal)
                } else {
                    self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                }
                
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            if scrollView.contentOffset.y > 200 && backButton.currentImage == #imageLiteral(resourceName: "arrow") {
                self.backButton.setImage(#imageLiteral(resourceName: "blackArrow"), for: .normal)
                menuSectionIndexCollectionView.isHidden = false
                statusBarStyle = .default
            } else if scrollView.contentOffset.y < 200 && backButton.currentImage == #imageLiteral(resourceName: "blackArrow") {
                self.backButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
                menuSectionIndexCollectionView.isHidden = true
                statusBarStyle = .lightContent
            }
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    // item의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuSectionIndexCollectionView {
            return .init(width: 150, height: 60)
        }
        
        switch indexPath.section {
        case 1:
            return .init(width: view.frame.width, height: 135)
        case 2:
            return .init(width: view.frame.width, height: 50)
        case 3, 4, 5, 6:
            let commentString: String = self.foods[indexPath.item].foodContents + "\n" + self.foods[indexPath.item].foodName + "\n" + self.foods[indexPath.item].price + "\n"
            
            let size: CGSize = CGSize(width: view.frame.width - 2 * padding, height: 500)
            let estimatedForm = NSString(string: commentString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return .init(width: view.frame.width - 2 * padding, height: estimatedForm.height + 45)
        default:
            return .init(width: view.frame.width - 2 * padding, height: 0)
        }
    }
}

extension CollectionViewController: SearchBarDelegate {
    func showSeachBar() {
        print("showSearchBar")
        let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let searchController = myStoryBoard.instantiateViewController(withIdentifier: "searchViewController")
        
        self.addChild(searchController)
        searchController.view.frame = self.view.frame
        
        self.view.addSubview(searchController.view)
        searchController.didMove(toParent: self)
        
    }
}

extension CollectionViewController: HeaderItemSizeDelegate {
    func changedContentOffset(value: CGFloat, lastValue: CGFloat) {
        guard let firstHeaderView = self.firstHeaderView else {
            return
        }
        let width = self.collectionView.frame.width
        
//        if value < 100 {
//            firstHeaderView.titleView.titleLabel.numberOfLines = 1
//        } else {
        if value > 100 {
            firstHeaderView.titleView.titleLabel.numberOfLines = 1
        } else {
            firstHeaderView.titleView.titleLabel.numberOfLines = 0
        }
        
        if value < 190 {
            
            firstHeaderView.titleViewWidthConstraint.constant = value/3 - 50
            firstHeaderView.titleViewHeightConstraint.constant = -value/7
            if value > lastValue {
                firstHeaderView.titleView.detailLabel.alpha = firstHeaderView.titleView.detailLabel.alpha - 0.006
                firstHeaderView.titleView.timeAndGradeLabel.alpha = firstHeaderView.titleView.timeAndGradeLabel.alpha - 0.006
                firstHeaderView.titleView.titleLabelLeadingConstraint.constant =
                    firstHeaderView.titleView.titleLabelLeadingConstraint.constant + value * 0.002
                firstHeaderView.titleView.titleLabelTrailingConstraint.constant =
                    firstHeaderView.titleView.titleLabelTrailingConstraint.constant - value * 0.002
                firstHeaderView.titleView.titleLabelTopConstraint.constant = firstHeaderView.titleView.titleLabelTopConstraint.constant + value * 0.002
            } else if value < lastValue {
                firstHeaderView.titleView.detailLabel.alpha = firstHeaderView.titleView.detailLabel.alpha + 0.006
                firstHeaderView.titleView.timeAndGradeLabel.alpha = firstHeaderView.titleView.timeAndGradeLabel.alpha + 0.006
                firstHeaderView.titleView.titleLabelLeadingConstraint.constant =
                    firstHeaderView.titleView.titleLabelLeadingConstraint.constant - value * 0.002
                
                firstHeaderView.titleView.titleLabelTrailingConstraint.constant =
                    firstHeaderView.titleView.titleLabelTrailingConstraint.constant + value * 0.002
                
                
                firstHeaderView.titleView.titleLabelTopConstraint.constant = firstHeaderView.titleView.titleLabelTopConstraint.constant - value * 0.002
            }
            
        }
        self.collectionView.layoutIfNeeded()
    }
}
