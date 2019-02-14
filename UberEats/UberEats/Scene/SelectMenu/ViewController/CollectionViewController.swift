//
//  CollectionViewController.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 21/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//
import UIKit
import Common

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

    var storeId: String? {
        didSet {
            print("storeId \(storeId)")
        }
    }

    var foodId: String? {
        didSet {
            print("foodId \(foodId)")
        }
    }

    private let padding: CGFloat = 5
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    private var isLiked: Bool = false
    private var isScrolling: Bool = false
    private var isChangedSection: Bool = false
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
        layout.minimumInteritemSpacing = ValuesForCollectionView.menuBarMinSpacing
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = ValuesForCollectionView.menuBarZeroAlpha
        collectionView.contentInset = UIEdgeInsets(top: ValuesForCollectionView.menuBarZeroInset,
                                                   left: ValuesForCollectionView.menuBarLeftInset,
                                                   bottom: ValuesForCollectionView.menuBarZeroInset,
                                                   right: ValuesForCollectionView.menuBarRightInset)
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

        collectionView.addSubview(storeTitleView)
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
            menuBarCollectionView.heightAnchor.constraint(equalToConstant: ValuesForCollectionView.menuBarHeightConstant),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: ValuesForButton.backAndLikeTopConstant),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: ValuesForButton.backLeadingConstant),
            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),

            likeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: ValuesForButton.backAndLikeTopConstant),
            likeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -ValuesForButton.likeTrailingConstant),
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
                                                            multiplier: ValuesForFloatingView.fullMultiplier,
                                                            constant: sectionNames[0].estimateCGRect.width
                                                                + ValuesForFloatingView.widthPadding)
        floatingViewWidthConstraint.isActive = true

        floatingViewLeadingConstraint = NSLayoutConstraint(item: floatingView,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: menuBarCollectionView,
                                                             attribute: .leading,
                                                             multiplier: ValuesForFloatingView.fullMultiplier,
                                                             constant: ValuesForFloatingView.leadingConstant)
        floatingViewLeadingConstraint.isActive = true

        NSLayoutConstraint.activate([
            floatingView.centerYAnchor.constraint(equalTo: self.menuBarCollectionView.centerYAnchor),
            floatingView.heightAnchor.constraint(equalToConstant: ValuesForFloatingView.heightConstant)
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
            return basicNumberOfItems
        default:
            return foods.count + DistanceBetween.titleAndFoodCell
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
            switch indexPath.item {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menu.rawValue,
                                                                    for: indexPath) as? SearchCollectionViewCell else {
                    return .init()
                }

                cell.title = self.sectionNames[indexPath.section - DistanceBetween.menuAndRest]

                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuDetail.rawValue,
                                                                    for: indexPath) as? FoodCollectionViewCell else {
                                                                        return .init()
                }

                cell.food = foods[indexPath.item - DistanceBetween.titleAndFoodCell]

                return cell
            }
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
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellId.tempHeader.rawValue, for: indexPath)
//                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                                   withReuseIdentifier: CellId.menuSection.rawValue,
//                                                                                   for: indexPath) as? MenuSectionView else {
//                    return .init()
//                }
//
//                header.menuTitle = sectionNames[indexPath.section - 3]
//
//                return header
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
            return CGSize(width: 0, height: HeightsOfHeader.menuBarAndMenu)
        }

        guard let section = SectionInStoreView(rawValue: section) else {
            return .init()
        }

        switch section {
        case .stretchyHeader:
            return .init(width: self.view.frame.width,
                         height: HeightsOfHeader.stretchy)
        default:
            return .init(width: self.view.frame.width,
                         height: HeightsOfHeader.food)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuBarCollectionView {
//            print("indexPath: \(collectionView.indexPathsForSelectedItems), \(isScrolling)")

            print("scrolling Value: \(isScrolling)")

            movingFloatingView(collectionView, indexPath)

            if !isScrolling {

                // 선택한 메뉴바의 카테고리에 대한 section목록으로 이동하는 부분
                let indx = IndexPath(item: 0, section: indexPath.item + DistanceBetween.menuAndRest)
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
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollWillBegin")
        isScrolling = true
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.contentOffset.y > 100 && scrollView.contentOffset.y < scrollLimit {
//            print("움직여라")
//            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
//        } else if scrollView.contentOffset.y < 100 {
//
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrolldidenddecelerating")
        isScrolling = false
    }

    private func getLikeButtonImageName(_ offsetY: CGFloat) -> String {
        if offsetY > AnimationValues.likeButtonChangeLimit {
            return "search"
        } else {
            return isLiked ? "selectLike" : "like"
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.menuBarCollectionView {

            self.likeButton.setImage(UIImage(named: getLikeButtonImageName(scrollView.contentOffset.y)), for: .normal)

            if scrollView.contentOffset.y > AnimationValues.scrollLimit
                && backButton.currentImage == UIImage(named: "arrow") {

                self.collectionView.contentInset = UIEdgeInsets(top: storeTitleView.frame.height,
                                                                left: ValuesForCollectionView.menuBarZeroInset,
                                                                bottom: ValuesForCollectionView.menuBarZeroInset,
                                                                right: ValuesForCollectionView.menuBarZeroInset)

                UIView.animate(withDuration: AnimationValues.duration,
                               delay: AnimationValues.delay,
                               options: .curveEaseIn,
                               animations: {
                                self.backButton.setImage(UIImage(named: "blackArrow"), for: .normal)
                                self.menuBarCollectionView.alpha = ValuesForCollectionView.menuBarFullAlpha
                }, completion: { _ in
                    self.statusBarStyle = .default
                })
            } else if scrollView.contentOffset.y < AnimationValues.scrollLimit
                && backButton.currentImage == UIImage(named: "blackArrow") {

                self.collectionView.contentInset = UIEdgeInsets(top: ValuesForCollectionView.menuBarZeroInset,
                                                                left: ValuesForCollectionView.menuBarZeroInset,
                                                                bottom: ValuesForCollectionView.menuBarZeroInset,
                                                                right: ValuesForCollectionView.menuBarZeroInset)

                UIView.animate(withDuration: AnimationValues.duration,
                               delay: AnimationValues.delay,
                               options: .curveEaseIn, animations: {
                                self.backButton.setImage(UIImage(named: "arrow"), for: .normal)
                                self.menuBarCollectionView.alpha = ValuesForCollectionView.menuBarZeroAlpha
                }, completion: { _ in
                    self.statusBarStyle = .lightContent
                })
            }

            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
            handleStoreView(by: scrollView)

            // collectionView.frame.width * 0.9 * 0.5 - 38 => storeTitleView의 높이
            let yPoint = collectionView.contentOffset.y
                            + collectionView.frame.width
                            * ValuesForStoreView.widthMultiplier
                            * ValuesForStoreView.heightMultiplier
                            - ValuesForStoreView.distanceBetweenHeightAfterStick + 15

//            print("lastSection: \(lastSection), current: \(collectionView.indexPathForItem(at: CGPoint(x: 100, y: yPoint)))")

            guard let currentSection = collectionView.indexPathForItem(at: CGPoint(x: 100,
                                                                                   y: yPoint))?.section else {
                return
            }

            print("currentSection: \(currentSection), lastSection: \(lastSection), isScrolling: \(isScrolling)")

            isChangedSection = (lastSection != currentSection)

            if currentSection >= menuStartSection && isChangedSection && isScrolling {
                print("willChangeSelectedItem")

                let lastIndexPath = IndexPath(item: lastSection - DistanceBetween.menuAndRest, section: 0)
                collectionView(menuBarCollectionView, didDeselectItemAt: lastIndexPath)

                let indexPathToMove = IndexPath(item: currentSection - DistanceBetween.menuAndRest, section: 0)
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

        floatingViewWidthConstraint.constant = estimatedForm.width + ValuesForFloatingView.widthPadding

        floatingViewLeadingConstraint.constant = cell.frame.minX

        UIView.animate(withDuration: AnimationValues.duration,
                       delay: AnimationValues.delay,
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

            return .init(width: estimatedForm.width + ValuesForFloatingView.widthPadding,
                         height: HeightsOfCell.menuBarAndMenu)
        }

        guard let section = SectionInStoreView(rawValue: indexPath.section) else {
            return .init()
        }

        switch section {
        case .stretchyHeader:
            return .init(width: view.frame.width - 2 * padding,
                         height: HeightsOfCell.empty)
        case .timeAndLocation:
            return .init(width: view.frame.width,
                         height: view.frame.height * HeightsOfCell.timeAndLocationMultiplier)
        case .menu:
            return .init(width: view.frame.width,
                         height: HeightsOfCell.menuBarAndMenu)
        default:
            if indexPath.item != 0 {
                let commentString: String = self.foods[indexPath.item - 1].foodContents + "\n" +
                    self.foods[indexPath.item - DistanceBetween.titleAndFoodCell].foodName + "\n" +
                    self.foods[indexPath.item - DistanceBetween.titleAndFoodCell].price + "\n"

                return .init(width: view.frame.width - 2 * padding, height: commentString.estimateCGRect.height + 45)
            }
            return .init(width: view.frame.width, height: HeightsOfCell.food)
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
        let headerHeight: CGFloat = HeightsOfHeader.stretchy

//        print("currentScroll: \(currentScroll), headerHeight: \(headerHeight)")
        changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
    }

    private func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        self.storeTitleView.changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
        self.view.layoutIfNeeded()
    }
}
