//
//  CollectionViewController.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 21/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//
import UIKit

// swiftlint:disable all
class CollectionViewController: UICollectionViewController {
    
    struct Metric {
        static let headerHeight: CGFloat = 283
        static let titleTopMargin: CGFloat = 171
        static let scrollLimit: CGFloat = titleTopMargin
        static let titleLabelTopMargin: CGFloat = 25
        static let buttonSize: CGFloat = 25
        static let titleLabelLeadingMargin: CGFloat = 27
    }

    let sectionNames: [String] = ["나를 위한 추천 메뉴", "햄버거 단품 Single Burger", "햄버거 세트", "디저트 Dessert"]
    
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
    
    private var titleViewTopConstraint = NSLayoutConstraint()
    private var titleViewWidthConstraint = NSLayoutConstraint()
    private var titleViewHeightConstraint = NSLayoutConstraint()
    private var horizontalViewLeadingConstraint = NSLayoutConstraint()
    private var horizontalViewWidthConstraint = NSLayoutConstraint()
    
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
    
    let titleView: TitleCustomView = {
        let view = TitleCustomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        
        //shadow
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let horizontalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 18
        return view
    }()
    
    lazy var menuSectionIndexCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = 0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        setupHorizontalView()
        setupCollectionViewLayout()
    }

    // MARK: - Method

    func setupLayout() {
        tabBarController?.tabBar.isHidden = true

        view.addSubview(titleView)
        view.addSubview(backButton)
        view.addSubview(likeButton)
        menuSectionIndexCollectionView.addSubview(horizontalView)
        view.addSubview(menuSectionIndexCollectionView)

        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(touchUpLikeButton(_:)), for: .touchUpInside)
        
        titleViewTopConstraint = NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal,
                                                    toItem: view, attribute: .top,
                                                    multiplier: 1, constant: Metric.titleTopMargin)
        titleViewTopConstraint.isActive = true
        
        titleViewWidthConstraint = NSLayoutConstraint(item: titleView, attribute: .width, relatedBy: .equal,
                                                      toItem: view, attribute: .width,
                                                      multiplier: 0.9, constant: 0)
        titleViewWidthConstraint.isActive = true
        
        titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal,
                                                       toItem: titleView, attribute: .width,
                                                       multiplier: 0.5, constant: 0)
        titleViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            
            menuSectionIndexCollectionView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            menuSectionIndexCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuSectionIndexCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuSectionIndexCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: Metric.buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: Metric.buttonSize),
            
            likeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: Metric.buttonSize),
            likeButton.heightAnchor.constraint(equalToConstant: Metric.buttonSize)
            ])
    }

    func setupCollectionView() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        // scrollPostion에 none이 없어졌길래 .centeredVertically 사용했습니다.
        menuSectionIndexCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
        
        collectionView.backgroundColor = .white
        // scrollBar 없애기 위함
        collectionView.showsVerticalScrollIndicator = false
        
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
            // header와 collectionview와의 거리
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }

    func setupHorizontalView() {
        let size: CGSize = CGSize(width: view.frame.width - 2 * padding, height: 500)
        let estimatedForm = NSString(string: sectionNames[0]).boundingRect(with: size,
                                                                           options: .usesLineFragmentOrigin,
                                                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        horizontalViewWidthConstraint = NSLayoutConstraint(item: horizontalView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: estimatedForm.width + 10)
        horizontalViewWidthConstraint.isActive = true
        
        horizontalViewLeadingConstraint = NSLayoutConstraint(item: horizontalView, attribute: .leading, relatedBy: .equal,
                                                             toItem: menuSectionIndexCollectionView, attribute: .leading, multiplier: 1, constant: 0)
        horizontalViewLeadingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            horizontalView.centerYAnchor.constraint(equalTo: self.menuSectionIndexCollectionView.centerYAnchor),
            horizontalView.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    
    // Object-C Method

    @objc func touchUpBackButton(_: UIButton) {
        tabBarController?.tabBar.isHidden = false
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

    // MARK: - Delegate, DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.menuSectionIndexCollectionView {
            return 1
        } else {
            return 7
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == self.menuSectionIndexCollectionView {
            return 4
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
            
            collectionView.sendSubviewToBack(horizontalView)
            
            cell.sectionName = sectionNames[indexPath.item]
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
                
                return header
            case 3, 4, 5, 6:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: smallMenuId, for: indexPath) as? SmallMenuHeaderView else {
                    return UICollectionReusableView()
                }

                header.menuLabel.text = sectionNames[indexPath.item]

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
            return CGSize(width: 0, height: 0)
        }

        switch section {
        case 0:
            return CGSize(width: self.view.frame.width, height: Metric.headerHeight)
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
            guard let cell = collectionView.cellForItem(at: indexPath) as? MenuSectionCollectionViewCell else {
                return
            }
            
            collectionView.bringSubviewToFront(cell)
            
            //이 부분 합치는 바깥으로 빼는거 물어봐야징
            let commentString: String = self.sectionNames[indexPath.item]
            
            let size: CGSize = CGSize(width: view.frame.width - 2 * padding, height: 500)
            let estimatedForm = NSString(string: commentString).boundingRect(with: size,
                                                                             options: .usesLineFragmentOrigin,
                                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            horizontalViewWidthConstraint.constant = estimatedForm.width + 10
            
            horizontalViewLeadingConstraint.constant = cell.frame.minX
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.menuSectionIndexCollectionView.layoutIfNeeded()
                }, completion: nil)
            
            // 메뉴바의 카테고리를 선택했을 때 왼쪽으로 붙이는 부분
            let sectionIndx = IndexPath(item: indexPath.item, section: 0)
            collectionView.selectItem(at: sectionIndx, animated: true, scrollPosition: .left)
            
            // 선택한 메뉴바의 카테고리에 대한 section목록으로 이동하는 부분
            let indx = IndexPath(item: 0, section: indexPath.item + 3)
            self.collectionView.selectItem(at: indx, animated: true, scrollPosition: .top)
            
        } else {
            let storyboard = UIStoryboard.init(name: "FoodItemDetails", bundle: nil)
            let footItemVC = storyboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")

            self.navigationController?.pushViewController(footItemVC, animated: true)
        }
    }
    
    // MARK: - ScrollView

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.menuSectionIndexCollectionView {
            if scrollView.contentOffset.y > 320 {
                self.likeButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
            } else {
                if likeStatus == true {
                    self.likeButton.setImage(#imageLiteral(resourceName: "selectLike"), for: .normal)
                } else {
                    self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                }
            }

            if scrollView.contentOffset.y > Metric.scrollLimit && backButton.currentImage == #imageLiteral(resourceName: "arrow") {
                
                self.collectionView.contentInset = UIEdgeInsets(top: titleView.frame.height + 80, left: 0, bottom: 0, right: 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.backButton.setImage(#imageLiteral(resourceName: "blackArrow"), for: .normal)
                    self.menuSectionIndexCollectionView.alpha = 1
                }, completion: { sccess in
                    self.statusBarStyle = .default
                })
            } else if scrollView.contentOffset.y < Metric.scrollLimit && backButton.currentImage == #imageLiteral(resourceName: "blackArrow") {
                
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.backButton.setImage(#imageLiteral(resourceName: "arrow"), for: .normal)
                    self.menuSectionIndexCollectionView.alpha = 0
                }, completion: { sccess in
                    self.statusBarStyle = .lightContent
                })
            }
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
            handleTitleView(by: scrollView)
        } else {
            
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    // item의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuSectionIndexCollectionView {
            let commentString: String = self.sectionNames[indexPath.item]
            
            let size: CGSize = CGSize(width: view.frame.width - 2 * padding, height: 500)
            let estimatedForm = NSString(string: commentString).boundingRect(with: size,
                                                                             options: .usesLineFragmentOrigin,
                                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return .init(width: estimatedForm.width + 10, height: 50)
        }

        switch indexPath.section {
        case 1:
            return .init(width: view.frame.width, height: view.frame.height * 0.15)
        case 2:
            return .init(width: view.frame.width, height: 50)
        case 3, 4, 5, 6:
            let commentString: String = self.foods[indexPath.item].foodContents + "\n" + self.foods[indexPath.item].foodName + "\n" + self.foods[indexPath.item].price + "\n"

            let size: CGSize = CGSize(width: view.frame.width - 2 * padding, height: 500)
            let estimatedForm = NSString(string: commentString).boundingRect(with: size,
                                                                             options: .usesLineFragmentOrigin,
                                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)

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

extension CollectionViewController {
    func handleTitleView(by scrollView: UIScrollView) {
        let currentScroll: CGFloat = scrollView.contentOffset.y
        let headerHeight: CGFloat = Metric.headerHeight
        
        print("currentScroll: \(currentScroll), headerHeight: \(headerHeight)")
        changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
    }
    
    func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        
//        let diff: CGFloat = headerHeight - currentScroll
        
        titleView.titleLabel.numberOfLines = currentScroll > (Metric.scrollLimit - 10) ? 1 : 2
        
        titleViewTopConstraint.constant = Metric.titleTopMargin - currentScroll
        
        if currentScroll < Metric.scrollLimit && currentScroll > 0 {
            titleViewWidthConstraint.constant = currentScroll * 0.2
            titleViewHeightConstraint.constant = -(currentScroll * 0.2)
            titleView.titleLabelTopConstraint.constant = (currentScroll * 0.2) + Metric.titleLabelTopMargin
            titleView.detailLabel.alpha = 1 - currentScroll/Metric.scrollLimit
            titleView.timeAndGradeLabel.alpha = 0.8 - currentScroll/Metric.scrollLimit
            
            titleView.titleLabelLeadingConstraint.constant = currentScroll * 0.1 + Metric.titleLabelLeadingMargin
            titleView.titleLabelTrailingConstraint.constant = -(currentScroll * 0.1 + Metric.titleLabelLeadingMargin)
            
        } else if currentScroll > Metric.scrollLimit {
            titleViewTopConstraint.constant = 0
            titleViewWidthConstraint.constant = self.collectionView.frame.width * 0.1
            titleViewHeightConstraint.constant = -38
            titleView.titleLabelTopConstraint.constant = Metric.titleLabelTopMargin * 2.3
            
            titleView.titleLabelLeadingConstraint.constant = Metric.buttonSize + 20
            titleView.titleLabelTrailingConstraint.constant = -(Metric.buttonSize + 20)
            
        }
        self.view.layoutIfNeeded()
    }
}
