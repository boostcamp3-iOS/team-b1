//
//  CollectionViewController.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 21/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//
import UIKit

class CollectionViewController: UICollectionViewController {
    
    struct Metric {
        static let headerHeight: CGFloat = 283
        static let titleTopMargin: CGFloat = 171
        static let scrollLimit: CGFloat = titleTopMargin
        static let titleLabelTopMargin: CGFloat = 25
        static let buttonSize: CGFloat = 25
        static let titleLabelLeadingMargin: CGFloat = 27
    }
    
    private let numberOfItemsInMenuBar = 6

    private let foods: [Food] = [Food.init(foodName: "제육정식 Korean Set with Grilled Pork",
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

    private let padding: CGFloat = 5
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    private var isLiked: Bool = false
    
    private var storeViewTopConstraint = NSLayoutConstraint()
    private var storeViewWidthConstraint = NSLayoutConstraint()
    private var storeViewHeightConstraint = NSLayoutConstraint()

    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrow"), for: .normal)
        return button
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like"), for: .normal)
        return button
    }()
    
    private let storeView: TitleCustomView = {
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
    
    lazy var menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = 0
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        setupCollectionViewLayout()
    }

    // MARK: - Method

    private func setupLayout() {
        tabBarController?.tabBar.isHidden = true

        view.addSubview(storeView)
        view.addSubview(backButton)
        view.addSubview(likeButton)
        view.addSubview(menuBarCollectionView)

        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(touchUpLikeButton(_:)), for: .touchUpInside)
        
        storeViewTopConstraint = NSLayoutConstraint(item: storeView, attribute: .top, relatedBy: .equal,
                                                    toItem: view, attribute: .top,
                                                    multiplier: 1, constant: Metric.titleTopMargin)
        storeViewTopConstraint.isActive = true
        
        storeViewWidthConstraint = NSLayoutConstraint(item: storeView, attribute: .width, relatedBy: .equal,
                                                      toItem: view, attribute: .width,
                                                      multiplier: 0.9, constant: 0)
        storeViewWidthConstraint.isActive = true
        
        storeViewHeightConstraint = NSLayoutConstraint(item: storeView, attribute: .height, relatedBy: .equal,
                                                       toItem: storeView, attribute: .width,
                                                       multiplier: 0.5, constant: 0)
        storeViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            storeView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            
            menuBarCollectionView.bottomAnchor.constraint(equalTo: storeView.bottomAnchor),
            menuBarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBarCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
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

    private func setupCollectionView() {
        // collectionView가 위에 safeArea까지 사용하게 한다.
        // contentInsetAdjustmentBehavior를 never로 하면 scroll view content insets는 절대 조정되지 않는다.
        collectionView.contentInsetAdjustmentBehavior = .never
        
        // scrollBar 없애기 위함
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellId.temp.rawValue)
        
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.header.rawValue)
        
        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.tempHeader.rawValue)

        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: CellId.menuDetail.rawValue)

        let storeNib = UINib(nibName: XibName.storeInfo.rawValue, bundle: nil)
        self.collectionView.register(storeNib, forCellWithReuseIdentifier: CellId.store.rawValue)

        let menuNib = UINib(nibName: XibName.search.rawValue, bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: CellId.menu.rawValue)

        let smallMenuNib = UINib(nibName: XibName.smallMenu.rawValue, bundle: nil)
        self.collectionView.register(smallMenuNib,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: CellId.smallMenu.rawValue)

        menuBarCollectionView.register(TempCollectionReusableView.self,
                                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: CellId.tempHeader.rawValue)

        let menuSectionNib = UINib(nibName: XibName.menuSection.rawValue, bundle: nil)
        menuBarCollectionView.register(menuSectionNib, forCellWithReuseIdentifier: CellId.menuSection.rawValue)

    }

    private func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? StretchyHeaderLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }

    // Object-C Method

    @objc private func touchUpBackButton(_: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpLikeButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "like") {
            sender.setImage(UIImage(named: "selectLike"), for: .normal)
            isLiked = true
        } else {
            sender.setImage(UIImage(named: "like"), for: .normal)
            isLiked = false
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    // MARK: - DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.menuBarCollectionView {
            return NumberOfSection.menuBar.rawValue
        } else {
            return NumberOfSection.collectionView.rawValue
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == self.menuBarCollectionView {
            return numberOfItemsInMenuBar
        }

        switch section {
        case SectionInSelectMenuView.stretchyHeader.rawValue ... SectionInSelectMenuView.menu.rawValue:
            return 1
        default:
            return foods.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuBarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuSection.rawValue,
                                                                for: indexPath) as? MenuSectionCollectionViewCell else {
                return .init()
            }
            
            cell.sectionName = "나를 위한 메뉴"
            cell.isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
            
            return cell
        }
    
        guard let section = SectionInSelectMenuView(rawValue: indexPath.section) else {
            return .init()
        }
        
        switch section {
        case .stretchyHeader:
            // .init()하면 에러 떠서 .init() 사용하지 않았습니다
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellId.temp.rawValue, for: indexPath)
        case .timeAndLocation:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.store.rawValue, for: indexPath)

            return cell
        case .menu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menu.rawValue,
                                                                for: indexPath) as? SearchCollectionViewCell else {
                return .init()
            }
            
            cell.searchBarDelegate = self
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuDetail.rawValue,
                                                                for: indexPath) as? FoodCollectionViewCell else {
                return .init()
            }

            cell.food = foods[indexPath.item]

            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            if collectionView == self.menuBarCollectionView {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                             for: indexPath)
                return header
            }

            guard let section = SectionInSelectMenuView(rawValue: indexPath.section) else {
                return .init()
            }
            
            switch section {
            case .stretchyHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.header.rawValue,
                                                                                   for: indexPath) as? HeaderView else {
                    return .init()
                }
                
                return header
                
            case .timeAndLocation, .menu:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                             for: indexPath)
                
                return header
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.smallMenu.rawValue,
                                                                                   for: indexPath)
                    as? SmallMenuHeaderView else {
                    return .init()
                }

                header.menuLabel.text = "나를 위한 추천 메뉴"

                return header
            }
        }

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: CellId.tempHeader.rawValue,
                                                               for: indexPath)
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.menuBarCollectionView {
            return .init(width: 20, height: 80)
        }
        
        guard let section = SectionInSelectMenuView(rawValue: section) else {
            return .init()
        }
        
        switch section {
        case .stretchyHeader:
            return .init(width: self.view.frame.width, height: Metric.headerHeight)
        case .timeAndLocation:
            return .init(width: self.view.frame.width, height: 1)
        case .menu:
            return .init(width: self.view.frame.width, height: 0)
        default:
            return .init(width: self.view.frame.width, height: 70)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuBarCollectionView {
            // 선택한 section목록으로 이동시키는 부분
            let indexToMove = IndexPath(item: 0, section: indexPath.row + 3)
            self.collectionView.selectItem(at: indexToMove, animated: true, scrollPosition: .top)
        } else {
            let storyboard = UIStoryboard.init(name: "FoodItemDetails", bundle: nil)
            let footItemVC = storyboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")

            self.navigationController?.pushViewController(footItemVC, animated: true)
        }
    }

    // MARK: - ScrollView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.menuBarCollectionView {
            
            if scrollView.contentOffset.y > 320 {
                self.likeButton.setImage(UIImage(named: "search"), for: .normal)
            } else {
                isLiked == true ? self.likeButton.setImage(UIImage(named: "selectLike"), for: .normal)
                                : self.likeButton.setImage(UIImage(named: "like"), for: .normal)
            }

            if scrollView.contentOffset.y > Metric.scrollLimit
                && backButton.currentImage == UIImage(named: "arrow") {
                
                self.collectionView.contentInset = UIEdgeInsets(top: storeView.frame.height + 80, left: 0,
                                                                bottom: 0, right: 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                               options: .curveEaseIn, animations: {
                                self.backButton.setImage(UIImage(named: "blackArrow"), for: .normal)
                                    self.menuBarCollectionView.alpha = 1
                                }, completion: { _ in
                                    self.statusBarStyle = .default
                                })
                
            } else if scrollView.contentOffset.y < Metric.scrollLimit
                && backButton.currentImage == UIImage(named: "blackArrow") {
                
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                               options: .curveEaseIn, animations: {
                                    self.backButton.setImage(UIImage(named: "arrow"), for: .normal)
                                    self.menuBarCollectionView.alpha = 0
                                }, completion: { _ in
                                    self.statusBarStyle = .lightContent
                                })
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
            handleStoreView(by: scrollView)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.menuBarCollectionView {
            return .init(width: 150, height: 60)
        }

        guard let section = SectionInSelectMenuView(rawValue: indexPath.section) else {
            return .init()
        }
        
        switch section {
        case .stretchyHeader:
            return .init(width: view.frame.width - 2 * padding, height: 0)
        case .timeAndLocation:
            return .init(width: view.frame.width, height: view.frame.height * 0.15)
        case .menu:
            return .init(width: view.frame.width, height: 50)
        default:
            let commentString: String = self.foods[indexPath.item].foodContents + "\n" +
                                        self.foods[indexPath.item].foodName + "\n" +
                                        self.foods[indexPath.item].price + "\n"

            let size: CGSize = CGSize(width: view.frame.width - 2 * padding, height: 500)
            let estimatedForm = NSString(string: commentString).boundingRect(with: size,
                                                                             options: .usesLineFragmentOrigin,
                                                                             attributes:
                                                    [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)],
                                                                             context: nil)

            return .init(width: view.frame.width - 2 * padding, height: estimatedForm.height + 45)
        }
    }
}

extension CollectionViewController: SearchBarDelegate {
    func showSeachBar() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "searchViewController")

        self.addChild(searchVC)
        searchVC.view.frame = self.view.frame

        self.view.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)
    }
}

extension CollectionViewController {
    private func handleStoreView(by scrollView: UIScrollView) {
        let currentScroll: CGFloat = scrollView.contentOffset.y
        let headerHeight: CGFloat = Metric.headerHeight
        
        print("currentScroll: \(currentScroll), headerHeight: \(headerHeight)")
        changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
    }
    
    private func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        
//        let diff: CGFloat = headerHeight - currentScroll
        
        storeView.titleLabel.numberOfLines = currentScroll > (Metric.scrollLimit - 10) ? 1 : 2
        
        storeViewTopConstraint.constant = Metric.titleTopMargin - currentScroll
        
        if currentScroll < Metric.scrollLimit && currentScroll > 0 {
            storeViewWidthConstraint.constant = currentScroll * 0.2
            storeViewHeightConstraint.constant = -(currentScroll * 0.2)
            storeView.titleLabelTopConstraint.constant = (currentScroll * 0.2) + Metric.titleLabelTopMargin
            storeView.detailLabel.alpha = 1 - currentScroll/Metric.scrollLimit
            storeView.timeAndGradeLabel.alpha = 0.8 - currentScroll/Metric.scrollLimit
            
            storeView.titleLabelLeadingConstraint.constant = currentScroll * 0.1 + Metric.titleLabelLeadingMargin
            storeView.titleLabelTrailingConstraint.constant = -(currentScroll * 0.1 + Metric.titleLabelLeadingMargin)
            
        } else if currentScroll > Metric.scrollLimit {
            storeViewTopConstraint.constant = 0
            storeViewWidthConstraint.constant = self.collectionView.frame.width * 0.1
            storeViewHeightConstraint.constant = -38
            storeView.titleLabelTopConstraint.constant = Metric.titleLabelTopMargin * 2.3
            
            storeView.titleLabelLeadingConstraint.constant = Metric.buttonSize + 20
            storeView.titleLabelTrailingConstraint.constant = -(Metric.buttonSize + 20)
            
        }
        self.view.layoutIfNeeded()
    }
}

private enum CellId: String {
    case temp = "tempId"
    case header = "headerId"
    case tempHeader = "tempHeaderId"
    case store = "storeId"
    case menu = "menuId"
    case smallMenu = "smallMenuId"
    case menuDetail = "menuDetailId"
    case menuSection = "menuSectionId"
}

private enum XibName: String {
    case storeInfo = "StoreInfoCollectionViewCell"
    case search = "SearchCollectionViewCell"
    case smallMenu = "SmallMenuHeaderView"
    case menuSection = "MenuSectionCollectionViewCell"
}

private enum NumberOfSection: Int {
    case menuBar = 1
    case collectionView = 7
}

private enum SectionInSelectMenuView: Int {
    case stretchyHeader = 0
    case timeAndLocation
    case menu
    // 예비
    case foodOne
    case foodTwo
    case foodThree
    case foodFour
}
