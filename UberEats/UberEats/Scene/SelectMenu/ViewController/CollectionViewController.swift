//
//  CollectionViewController.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 21/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//
import UIKit

public let buttonSize: CGFloat = 25

class CollectionViewController: UICollectionViewController {
    private let sectionNames: [String] = ["나를 위한 추천 메뉴", "햄버거 단품 Single Burger", "햄버거 세트", "디저트 Dessert"]

    private let foods: [Food] = [.init(foodName: "제육정식 Korean Set with Grilled Pork",
                                       foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                       price: "₩8,900", foodImage: nil),
                                 .init(foodName: "부대찌개개개개개ㅐ애애애애애애애 Korean Set with Grilled Pork",
                                       foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                       price: "₩8,900", foodImage: nil),
                                 .init(foodName: "햄버거 Korean Set with Grilled Pork",
                                       foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                       price: "₩8,900", foodImage: nil),
                                 .init(foodName: "피자 Korean Set with Grilled Pork",
                                       foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                       price: "₩1,000,900", foodImage: nil),
                                 .init(foodName: "부대찌개개개개개ㅐ애애애애애애애 Korean Set with Grilled Pork",
                                       foodContents: "알싸한 매콤함이 일품인 부거부거 최고 메뉴입니다.",
                                       price: "₩8,900", foodImage: nil)]

    private let headerHeight: CGFloat = 283
    private let scrollLimit: CGFloat = 171

    private let padding: CGFloat = 5
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    private var isLiked: Bool = false
    private var isScrolling: Bool = false
    private var lastSection: Int = 3

    private var identifier = ""

    private var storeTitleView = StoreTitleView()

    private var floatingViewLeadingConstraint = NSLayoutConstraint()
    private var floatingViewWidthConstraint = NSLayoutConstraint()

    private let backButton = UIButton().initButtonWithImage("arrow")
    private let likeButton = UIButton().initButtonWithImage("like")

    private let floatingView = FloatingView()

    lazy var menuBarCollectionView: UICollectionView = {
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
        setupFloatingView()
        setupCollectionViewLayout()
    }

    // MARK: - Method
    private func setupLayout() {
        tabBarController?.tabBar.isHidden = true

        storeTitleView = StoreTitleView(parentView: view)

        view.addSubview(storeTitleView)
        view.addSubview(backButton)
        view.addSubview(likeButton)
        menuBarCollectionView.addSubview(floatingView)
        view.addSubview(menuBarCollectionView)

        storeTitleView.setupConstraint()

        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(touchUpLikeButton(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            storeTitleView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),

            menuBarCollectionView.bottomAnchor.constraint(equalTo: storeTitleView.bottomAnchor),
            menuBarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBarCollectionView.heightAnchor.constraint(equalToConstant: 60),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),

            likeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            likeButton.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
    }

    private func setupCollectionView() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)
        //        collectionView(menuBarCollectionView, didSelectItemAt: selectedIndexPath)

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellId.temp.rawValue)

        collectionView.register(StretchyHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.stretchyHeader.rawValue)

        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.tempHeader.rawValue)

        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: CellId.menuDetail.rawValue)

        let timeAndLocationNib = UINib(nibName: XibName.timeAndLocation.rawValue, bundle: nil)
        self.collectionView.register(timeAndLocationNib, forCellWithReuseIdentifier: CellId.timeAndLocation.rawValue)

        let menuNib = UINib(nibName: XibName.search.rawValue, bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: CellId.menu.rawValue)

        let menuSectionNib = UINib(nibName: XibName.menuSection.rawValue, bundle: nil)
        self.collectionView.register(menuSectionNib,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: CellId.menuSection.rawValue)

        menuBarCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: CellId.tempHeader.rawValue)

        let menuCategoryNib = UINib(nibName: XibName.menuCategory.rawValue, bundle: nil)
        menuBarCollectionView.register(menuCategoryNib, forCellWithReuseIdentifier: CellId.menuCategory.rawValue)
    }

    private func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? StretchyHeaderLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }

    func setupFloatingView() {
        floatingViewWidthConstraint = NSLayoutConstraint(item: floatingView,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .width,
                                                            multiplier: 1,
                                                            constant: sectionNames[0].estimateCGRect.width + 10)
        floatingViewWidthConstraint.isActive = true

        floatingViewLeadingConstraint = NSLayoutConstraint(item: floatingView,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: menuBarCollectionView,
                                                             attribute: .leading,
                                                             multiplier: 1, constant: 0)
        floatingViewLeadingConstraint.isActive = true

        NSLayoutConstraint.activate([
            floatingView.centerYAnchor.constraint(equalTo: self.menuBarCollectionView.centerYAnchor),
            floatingView.heightAnchor.constraint(equalToConstant: 35)
            ])
    }

    // Object-C Method
    @objc private func touchUpBackButton(_: UIButton) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpLikeButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "like") {
            sender.setImage(UIImage(named: "selectLike"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "like"), for: .normal)
        }
        isLiked = !isLiked
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
            return sectionNames.count
        }

        guard let section = SectionInStoreView(rawValue: section) else {
            return 0
        }

        switch section {
        case .stretchyHeader, .timeAndLocation, .menu:
            return 1
        default:
            return foods.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuBarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuCategory.rawValue,
                                                                for: indexPath) as? MenuCategoryCollectionViewCell else {
                return .init()
            }

            collectionView.sendSubviewToBack(floatingView)

            cell.sectionName = sectionNames[indexPath.item]
            cell.setColor(by: collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false)

            return cell
        }

        guard let section = SectionInStoreView(rawValue: indexPath.section) else {
            return .init()
        }

        switch section {
        case .stretchyHeader:
            identifier = CellId.temp.rawValue
        case .timeAndLocation:
            identifier = CellId.timeAndLocation.rawValue
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
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            if collectionView == self.menuBarCollectionView {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                             for: indexPath)
                return header
            }

            guard let section = SectionInStoreView(rawValue: indexPath.section) else {
                return .init()
            }

            switch section {
            case .stretchyHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.stretchyHeader.rawValue,
                                                                                   for: indexPath) as? StretchyHeaderView else {
                    return .init()
                }

                return header

            case .timeAndLocation, .menu:
                identifier = CellId.tempHeader.rawValue
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.menuSection.rawValue,
                                                                                   for: indexPath) as? MenuSectionView else {
                    return .init()
                }

                header.menuLabel.text = sectionNames[indexPath.item]

                return header
            }
        }

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: identifier,
                                                               for: indexPath)
    }

    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        if collectionView == self.menuBarCollectionView {
            return CGSize(width: 0, height: 0)
        }

        guard let section = SectionInStoreView(rawValue: section) else {
            return .init()
        }

        switch section {
        case .stretchyHeader:
            return .init(width: self.view.frame.width, height: headerHeight)
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
            print("indexPath: \(collectionView.indexPathsForSelectedItems), \(isScrolling)")

            movingFloatingView(collectionView, indexPath)

            // 스크롤중인 경우
            if isScrolling {
                isScrolling = false
            } else {
                // 선택한 메뉴바의 카테고리에 대한 section목록으로 이동하는 부분
                let indx = IndexPath(item: 0, section: indexPath.item + 3)
                self.collectionView.selectItem(at: indx, animated: true, scrollPosition: .top)
            }
        } else {
            let storyboard = UIStoryboard.init(name: "FoodItemDetails", bundle: nil)
            let footItemVC = storyboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")

            self.navigationController?.pushViewController(footItemVC, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCategoryCollectionViewCell else {
            return
        }
        cell.setColor(by: false)
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

            if scrollView.contentOffset.y > scrollLimit
                && backButton.currentImage == UIImage(named: "arrow") {

                self.collectionView.contentInset = UIEdgeInsets(top: storeTitleView.frame.height + 80, left: 0,
                                                                bottom: 0, right: 0)

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                               options: .curveEaseIn, animations: {
                                self.backButton.setImage(UIImage(named: "blackArrow"), for: .normal)
                                self.menuBarCollectionView.alpha = 1
                }, completion: { _ in
                    self.statusBarStyle = .default
                })

            } else if scrollView.contentOffset.y < scrollLimit
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

            let yPoint = collectionView.contentOffset.y + collectionView.frame.width * 0.9 * 0.5 + 40

            guard let currentSection = collectionView.indexPathForItem(at: CGPoint(x: 100,
                                                                                   y: yPoint))?.section else {
                return
            }

            print("lastSection: \(lastSection), current: \(currentSection)")

            if currentSection > 2 && lastSection != currentSection {
                isScrolling = !isScrolling

                let lastIndexPath = IndexPath(item: lastSection - 3, section: 0)
                collectionView(menuBarCollectionView, didDeselectItemAt: lastIndexPath)

                let indexPathToMove = IndexPath(item: currentSection - 3, section: 0)
                collectionView(menuBarCollectionView, didSelectItemAt: indexPathToMove)
                lastSection = currentSection
            }
        }
    }

    func movingFloatingView(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCategoryCollectionViewCell else {
            return
        }

        collectionView.bringSubviewToFront(cell)

        let estimatedForm = self.sectionNames[indexPath.item].estimateCGRect

        floatingViewWidthConstraint.constant = estimatedForm.width + 10

        floatingViewLeadingConstraint.constant = cell.frame.minX

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.menuBarCollectionView.layoutIfNeeded()
        }, completion: nil)

        cell.setColor(by: true)

        // 메뉴바의 카테고리를 선택했을 때 왼쪽으로 붙이는 부분
        let sectionIndx = IndexPath(item: indexPath.item, section: 0)
        collectionView.selectItem(at: sectionIndx, animated: true, scrollPosition: .left)

    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuBarCollectionView {
            let estimatedForm = self.sectionNames[indexPath.item].estimateCGRect

            return .init(width: estimatedForm.width + 10, height: 50)
        }

        guard let section = SectionInStoreView(rawValue: indexPath.section) else {
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

            return .init(width: view.frame.width - 2 * padding, height: commentString.estimateCGRect.height + 45)
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
        let headerHeight: CGFloat = self.headerHeight

        print("currentScroll: \(currentScroll), headerHeight: \(headerHeight)")
        changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
    }

    private func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        self.storeTitleView.changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
        self.view.layoutIfNeeded()
    }
}

private enum CellId: String {
    case temp = "tempId"
    case stretchyHeader = "stretchyHeaderId"
    case tempHeader = "tempHeaderId"
    case timeAndLocation = "timeAndLocationId"
    case menu = "menuId"
    case menuCategory = "menuCategoryId"
    case menuDetail = "menuDetailId"
    case menuSection = "menuSectionId"
}

private enum XibName: String {
    case timeAndLocation = "TimeAndLocationCollectionViewCell"
    case search = "SearchCollectionViewCell"
    case menuSection = "MenuSectionView"
    case menuCategory = "MenuCategoryCollectionViewCell"
}

private enum NumberOfSection: Int {
    case menuBar = 1
    case collectionView = 7
}

private enum SectionInStoreView: Int {
    case stretchyHeader = 0
    case timeAndLocation
    case menu
    // 예비
    case foodOne
    case foodTwo
    case foodThree
    case foodFour
}
