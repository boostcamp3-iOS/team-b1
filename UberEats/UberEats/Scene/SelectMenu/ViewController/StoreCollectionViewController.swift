//
//  CollectionViewController.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 21/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//
import UIKit
import Common
import Service
import DependencyContainer
import ServiceInterface

class StoreCollectionViewController: UICollectionViewController {
    private var categorys: [String] = []

    func passingData(status: SelectState) {
        switch status {
        case .store(let storeId):
            self.storeId = storeId
        case .food(foodId: let foodId, storeId: let storeId):
            self.storeId = storeId
            self.foodId = foodId
        }
    }

    var storeId: String?
    var foodId: String?

    private var storeService: StoreService = DependencyContainer.share.getDependency(key: .storeService)
    private var foodsService: FoodsService = DependencyContainer.share.getDependency(key: .foodsService)

    private var store: Store?
    private var foods: [Food] = []
    private var foodsOfCategory: [String: [Food]] = [:]

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

        setupData()
        setupLayout()
        setupCollectionViewLayout()
    }

    // MARK: - Method
    private func setupData() {
        guard let storeId = storeId else {
            return
        }

        storeService.requestStore(query: storeId) { [weak self] (response) in
            if response.isSuccess {
                guard let store = response.value?.store else {
                    return
                }

                self?.storeTitleView.store = store
                self?.store = store
                self?.collectionView.reloadData()
            } else {
                fatalError()
            }
        }

        foodsService.requestFoods(query: storeId) { [weak self] (response) in
            if response.isSuccess {
                guard let foods = response.value?.foods else {
                    return
                }

                self?.foods = foods
                self?.seperateCategory()

                self?.collectionView.reloadData()
                self?.menuBarCollectionView.reloadData()

                self?.setupFloatingView()
                self?.setupCollectionView()
                self?.pushFoodDetail()
            } else {
                fatalError()
            }
        }
    }

    private func setupLayout() {
        navigationController?.navigationBar.isHidden = true
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

        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellId.temp.rawValue)

        // header
        collectionView.register(StretchyHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.stretchyHeader.rawValue)

        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.tempHeader.rawValue)

        menuBarCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: CellId.tempHeader.rawValue)

        // cell
        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: CellId.menuDetail.rawValue)

        let timeAndLocationNib = UINib(nibName: XibName.timeAndLocation.rawValue, bundle: nil)
        self.collectionView.register(timeAndLocationNib, forCellWithReuseIdentifier: CellId.timeAndLocation.rawValue)

        let menuNib = UINib(nibName: XibName.search.rawValue, bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: CellId.menu.rawValue)

        let menuCategoryNib = UINib(nibName: XibName.menuCategory.rawValue, bundle: nil)
        menuBarCollectionView.register(menuCategoryNib, forCellWithReuseIdentifier: CellId.menuCategory.rawValue)

        let menuSectionNib = UINib(nibName: XibName.menuSection.rawValue, bundle: nil)
        self.collectionView.register(menuSectionNib, forCellWithReuseIdentifier: CellId.menuSection.rawValue)
    }

    private func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? StretchyHeaderLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }

    private func setupFloatingView() {
        floatingViewWidthConstraint = NSLayoutConstraint(item: floatingView,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .width,
                                                            multiplier: ValuesForFloatingView.fullMultiplier,
                                                            constant: categorys[0].estimateCGRect.width
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

    private func pushFoodDetail() {
        if foodId != nil {
            let storyboard = UIStoryboard(name: "Cart", bundle: nil)
            let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartViewController

            guard let store = store else {
                return
            }

            var price: Int = 0
            var foodName: String = ""

            foods.forEach {
                if foodId == $0.id {
                    price = $0.basePrice
                    foodName = $0.foodName
                }
            }

            let storeInfo = StoreInfoModel.init(name: store.name, deliveryTime: store.deliveryTime)
            let deliveryInfoModel = DeilveryInfoModel.init(locationImage: "https://github.com/boostcamp3-iOS/team-b1/blob/master/images/FoodMarket/airInTheCafe.jpeg?raw=true",
                                                           detailedAddress: "서울특별시 강남구 역삼1동 강남대로 382",
                                                           address: "메리츠 타워",
                                                           deliveryMethod: .pickUpOutside,
                                                           roomNumber: 101)

            let cartModel = CartModel.init(storeInfo: storeInfo, deilveryInfo: deliveryInfoModel, foodOrderedInfo: nil)

            cartViewController.cartModel = cartModel
            cartViewController.orderInfoModels = [OrderInfoModel.init(amount: 1,
                                                                      orderName: foodName,
                                                                      price: price)]

            self.navigationController?.pushViewController(cartViewController, animated: true)
//            self.present(cartViewController, animated: true, completion: nil)
        }
    }

    private func seperateCategory() {
        foods.forEach {
            if !foodsOfCategory.keys.contains($0.categoryId) {
                foodsOfCategory.updateValue([], forKey: $0.categoryId)
                categorys.append($0.categoryName)
            }

            foodsOfCategory[$0.categoryId]?.append($0)
        }
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
            guard let numberOfCategory: Int = store?.numberOfCategory else {
                return 0
            }
            return numberOfCategory + DistanceBetween.menuAndRest
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.menuBarCollectionView {
            return categorys.count
        }

        switch section {
        case 0, 1, 2:
            return basicNumberOfItems
        default:
            guard let food = foodsOfCategory["category" + String(section - DistanceBetween.menuAndRest + 1)]?.count else {
                return 0
            }
            return food + DistanceBetween.titleAndFoodCell
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

            cell.sectionName = categorys[indexPath.item]
            cell.setColor(by: collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false)

            return cell
        }

        switch indexPath.section {
        case 0:
            identifier = CellId.temp.rawValue
        case 1:
            identifier = CellId.timeAndLocation.rawValue
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menu.rawValue,
                                                                for: indexPath) as? SearchCollectionViewCell else {
                                                                    return .init()
            }

            cell.searchBarDelegate = self

            return cell
        default:
            switch indexPath.item {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuSection.rawValue,
                                                                    for: indexPath) as? MenuSectionCollectionViewCell else {
                    return .init()
                }

                cell.menuLabel.text = categorys[indexPath.section - DistanceBetween.menuAndRest]

                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuDetail.rawValue,
                                                                    for: indexPath) as? FoodCollectionViewCell else {
                                                                        return .init()
                }

                guard let food = foodsOfCategory["category" + String(indexPath.section - DistanceBetween.menuAndRest + 1)]?[indexPath.item - DistanceBetween.titleAndFoodCell] else {
                    return .init()
                }

                cell.priceLabelBottomConstraint.isActive = (food.foodDescription == "") ? false : true
                cell.foodImageViewWidthConstraint.isActive = (food.foodImageURL == "") ? false : true

                cell.food = food

                guard let imageURL = URL(string: food.foodImageURL) else {
                    return cell
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (image, error) in
                    if error != nil {
                        return
                    }

                    cell.foodImageView.image = image
                }

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

            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.stretchyHeader.rawValue,
                                                                                   for: indexPath) as? StretchyHeaderView else {
                    return .init()
                }

                guard let imageURLString = store?.mainImage,
                    let imageURL = URL(string: imageURLString) else {
                        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                               for: indexPath)
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (image, error) in
                    if error != nil {
                        return
                    }

                    header.headerImageView.image = image
                }

                return header

            case 1, 2:
                identifier = CellId.tempHeader.rawValue
            default:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellId.tempHeader.rawValue, for: indexPath)
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

        switch section {
        case 0:
            return .init(width: self.view.frame.width,
                         height: HeightsOfHeader.stretchy)
        default:
            return .init(width: self.view.frame.width,
                         height: HeightsOfHeader.food)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuBarCollectionView {

            movingFloatingView(collectionView, indexPath)

            if !isScrolling {

                // 선택한 메뉴바의 카테고리에 대한 section목록으로 이동하는 부분
                let indx = IndexPath(item: 0, section: indexPath.item + DistanceBetween.menuAndRest)
                self.collectionView.selectItem(at: indx, animated: true, scrollPosition: .top)
            }
        } else {
            let storyboard = UIStoryboard(name: "Cart", bundle: nil)
            let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartViewController

            guard let store = store else {
                return
            }

            guard let price = foodsOfCategory["category" + String(indexPath.section - DistanceBetween.menuAndRest + 1)]?[indexPath.item - DistanceBetween.titleAndFoodCell].basePrice else {
                return
            }

            let storeInfo = StoreInfoModel.init(name: store.name, deliveryTime: store.deliveryTime)
            let deliveryInfoModel = DeilveryInfoModel.init(locationImage: "https://github.com/boostcamp3-iOS/team-b1/blob/master/images/FoodMarket/airInTheCafe.jpeg?raw=true",
                                                           detailedAddress: "메리츠 타워",
                                                           address: "서울특별시 강남구 역삼1동 강남대로 382",
                                                           deliveryMethod: .pickUpOutside,
                                                           roomNumber: 101)

            let cartModel = CartModel.init(storeInfo: storeInfo, deilveryInfo: deliveryInfoModel, foodOrderedInfo: nil)

            cartViewController.cartModel = cartModel
            cartViewController.orderInfoModels = [OrderInfoModel.init(amount: 1,
                                                                      orderName: "#12345",
                                                                      price: price)]

            self.present(cartViewController, animated: true, completion: nil)

//            let storyboard = UIStoryboard.init(name: "FoodItemDetails", bundle: nil)
//            let foodItemVC = storyboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")
//
//            foodItemVC.foodId = foodsOfCategory["category" + String(indexPath.section - DistanceBetween.menuAndRest + 1)]?[indexPath.item - DistanceBetween.titleAndFoodCell].id
//            foodItemVC.storeId = storeId

//            self.navigationController?.pushViewController(foodItemVC, animated: true)
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
        isScrolling = true
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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

            guard let currentSection = collectionView.indexPathForItem(at: CGPoint(x: 100,
                                                                                   y: yPoint))?.section else {
                return
            }

            isChangedSection = (lastSection != currentSection)

            if currentSection >= menuStartSection && isChangedSection && isScrolling {
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

        let estimatedForm = self.categorys[indexPath.item].estimateCGRect

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

extension StoreCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuBarCollectionView {
            let estimatedForm = self.categorys[indexPath.item].estimateCGRect

            return .init(width: estimatedForm.width + ValuesForFloatingView.widthPadding,
                         height: HeightsOfCell.menuBarAndMenu)
        }

        switch indexPath.section {
        case 0:
            return .init(width: view.frame.width - 2 * padding,
                         height: HeightsOfCell.empty)
        case 1:
            return .init(width: view.frame.width,
                         height: view.frame.height * HeightsOfCell.timeAndLocationMultiplier)
        case 2:
            return .init(width: view.frame.width,
                         height: HeightsOfCell.menuBarAndMenu)
        default:
            if indexPath.item != 0 {
                if self.foods[indexPath.item - 1].foodDescription == "" {
                    return .init(width: view.frame.width - 2 * padding, height: 120)
                } else {
                    let commentString: String = self.foods[indexPath.item - 1].foodDescription + "\n" +
                        self.foods[indexPath.item - DistanceBetween.titleAndFoodCell].foodName + "\n" +
                        String(self.foods[indexPath.item - DistanceBetween.titleAndFoodCell].basePrice) + "\n"

                    return .init(width: view.frame.width - 2 * padding, height: commentString.estimateCGRect.height + 45)
                }
            }
            return .init(width: view.frame.width, height: HeightsOfCell.food)
        }
    }
}

extension StoreCollectionViewController: SearchBarDelegate {
    func showSeachBar() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "searchViewController")

        self.addChild(searchVC)
        searchVC.view.frame = self.view.frame

        self.view.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)
    }
}

extension StoreCollectionViewController {
    private func handleStoreView(by scrollView: UIScrollView) {
        let currentScroll: CGFloat = scrollView.contentOffset.y
        let headerHeight: CGFloat = HeightsOfHeader.stretchy

        changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
    }

    private func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        self.storeTitleView.changedContentOffset(currentScroll: currentScroll, headerHeight: headerHeight)
        self.view.layoutIfNeeded()
    }
}
