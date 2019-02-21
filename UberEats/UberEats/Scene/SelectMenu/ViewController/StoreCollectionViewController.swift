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

    private var storeService: StoreService = DependencyContainer.share.getDependency(key: .storeService)
    private var foodsService: FoodsService = DependencyContainer.share.getDependency(key: .foodsService)

    var storeId: String?
    var foodId: String?

    var orderFoods: [OrderInfoModel] = []
    private var store: StoreForView?
    private var foods: [FoodForView] = [] {
        didSet {
            foods.forEach {
                if let imageURL = URL(string: $0.lowImageURL) {
                    ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { (_, error) in
                        if error != nil {
                            return
                        }

                        self.dataIndicator.stopAnimating()
                        self.collectionView.isScrollEnabled = true
                    }
                }
            }
        }
    }

    private var foodsOfCategory: [String: [FoodForView]] = [:]

    private var statusBarStyle: UIStatusBarStyle = .lightContent
    private var lastSection: Int = 3
    private let padding: CGFloat = 5

    private var isLiked: Bool = false
    private var isScrolling: Bool = false
    private var isChangedSection: Bool = false

    private var identifier = ""

    private var floatingViewLeadingConstraint = NSLayoutConstraint()
    private var floatingViewWidthConstraint = NSLayoutConstraint()

    private let floatingView = FloatingView()
    private var storeTitleView = StoreTitleView()
    private let backButton = UIButton().initButtonWithImage("arrow")
    private let likeButton = UIButton().initButtonWithImage("like")

    private let sectionHeader = UICollectionView.elementKindSectionHeader
    private let sectionFooter = UICollectionView.elementKindSectionFooter

    lazy var dataIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0,
                                 y: self.view.frame.maxY / 2,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height / 2)
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        indicator.backgroundColor = .white
        return indicator
    }()

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
        dataIndicator.startAnimating()
        collectionView.isScrollEnabled = false

        guard let storeId = storeId else {
            return
        }

        storeService.requestStore(storeId: storeId, dispatchQueue: .global()) { [weak self] (response) in
            guard response.isSuccess,
                let store = response.value?.store else {
                return
            }

            self?.storeTitleView.store = store
            self?.store = store

            self?.collectionView.reloadData()
        }

        foodsService.requestFoods(storeId: storeId, dispatchQueue: .global()) { [weak self] (response) in
            guard response.isSuccess,
                let foods = response.value?.foods else {
                return
            }

            self?.foods = foods
            self?.seperateCategory()

            self?.collectionView.reloadData()
            self?.menuBarCollectionView.reloadData()

            self?.setupFloatingView()
            self?.setupCollectionView()
            self?.pushFoodDetail()
        }
    }

    private func setupLayout() {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true

        storeTitleView = StoreTitleView(view)

        collectionView.addSubview(storeTitleView)
        collectionView.addSubview(dataIndicator)
        view.addSubview(backButton)
        view.addSubview(likeButton)
        view.addSubview(menuBarCollectionView)
        menuBarCollectionView.addSubview(floatingView)

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

        // header
        collectionView.register(StretchyHeaderView.self,
                                forSupplementaryViewOfKind: sectionHeader,
                                withReuseIdentifier: CellId.stretchyHeader.rawValue)

        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: sectionHeader,
                                withReuseIdentifier: CellId.tempHeader.rawValue)

        menuBarCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: sectionHeader,
                                       withReuseIdentifier: CellId.tempHeader.rawValue)

        // footer
        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: sectionFooter,
                                withReuseIdentifier: CellId.tempFooter.rawValue)

        // cell
        collectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: CellId.menuDetail.rawValue)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellId.temp.rawValue)

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
                                                                + ValuesForFloatingView.widthPadding + 20)
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

    private func seperateCategory() {
        foods.forEach {
            if !foodsOfCategory.keys.contains($0.categoryId) {
                foodsOfCategory.updateValue([], forKey: $0.categoryId)
                categorys.append($0.categoryName)
            }

            foodsOfCategory[$0.categoryId]?.append($0)
        }
    }

    private func pushFoodDetail() {
        if foodId != nil {
            let storyboard = UIStoryboard(name: "FoodItemDetails", bundle: nil)
            let foodDetailsViewController = storyboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC") as! FoodItemDetailsViewController

//            guard let store = store else {
//                return
//            }
//
//            var price: Int = 0
//            var foodName: String = ""
//
//            foods.forEach {
//                if foodId == $0.id {
//                    price = $0.basePrice
//                    foodName = $0.foodName
//                }
//            }
//
//            let storeInfo = StoreInfoModel.init(name: store.name, deliveryTime: store.deliveryTime)
//            let deliveryInfoModel = DeilveryInfoModel.init(locationImage: "https://github.com/boostcamp3-iOS/team-b1/blob/master/images/FoodMarket/airInTheCafe.jpeg?raw=true",
//                                                           detailedAddress: "서울특별시 강남구 역삼1동 강남대로 382",
//                                                           address: "메리츠 타워",
//                                                           deliveryMethod: .pickUpOutside,
//                                                           roomNumber: 101)
//
//            let cartModel = CartModel.init(storeInfo: storeInfo, deilveryInfo: deliveryInfoModel, foodOrderedInfo: nil)
//
//            cartViewController.cartModel = cartModel
//            cartViewController.orderInfoModels = [OrderInfoModel.init(amount: 1,
//                                                                      orderName: foodName,
//                                                                      price: price)]

            self.navigationController?.pushViewController(foodDetailsViewController, animated: true)
            //            self.present(cartViewController, animated: true, completion: nil)
        }
    }

    // Object-C Method
    @objc private func touchUpBackButton(_: UIButton) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpLikeButton(_ sender: UIButton) {
        let imageName = sender.currentImage == UIImage(named: "like") ? "selectLike" : "like"
        sender.setImage(UIImage(named: imageName), for: .normal)

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
            let categoryId: String = "category" + String(section - DistanceBetween.menuAndRest + 1)
            guard let food = foodsOfCategory[categoryId]?.count else {
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

                let categoryId: String = "category" + String(indexPath.section - DistanceBetween.menuAndRest + 1)
                let foodIndex: Int = indexPath.item - DistanceBetween.titleAndFoodCell

                guard let food: FoodForView = foodsOfCategory[categoryId]?[foodIndex] else {
                    return .init()
                }

                cell.priceLabelBottomConstraint.isActive = (food.foodDescription == "") ? false : true
                cell.foodImageViewWidthConstraint.constant = (food.lowImageURL == "") ? 0 : 100

                cell.food = food

                guard let imageURL = URL(string: food.lowImageURL) else {
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
                        return header
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
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                       for: indexPath)
            }
        } else {
            if collectionView == self.collectionView {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: CellId.tempFooter.rawValue,
                                                                       for: indexPath) as? TempCollectionReusableView else {
                    return .init()
                }

                footer.backgroundColor = #colorLiteral(red: 0.8638877273, green: 0.8587527871, blue: 0.8678352237, alpha: 1)

                return footer
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
            return .init(width: 0, height: HeightsOfHeader.menuBarAndMenu)
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if section > 2 {
            return .init(width: self.view.frame.width,
                         height: 0.5)
        }

        return .init(width: 0, height: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuBarCollectionView {

            movingFloatingView(collectionView, indexPath)

            if !isScrolling {
                let sectionIndex: Int = indexPath.item + DistanceBetween.menuAndRest
                let indexToMove = IndexPath(item: 0, section: sectionIndex)
                self.collectionView.selectItem(at: indexToMove, animated: true, scrollPosition: .top)
            }
        } else {
            switch indexPath.section {
            case 0, 1, 2:
                return
            default:
                if indexPath.item == 0 {
                    return
                }

                let storyboard = UIStoryboard(name: "Cart", bundle: nil)
                guard let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartVC")
                    as? CartViewController else {
                        return
                }

                guard let store = store else {
                    return
                }

                let categoryId: String = "category" + String(indexPath.section - DistanceBetween.menuAndRest + 1)
                let foodIndex: Int = indexPath.item - DistanceBetween.titleAndFoodCell

                guard let selectedFood = foodsOfCategory[categoryId]?[foodIndex] else {
                    return
                }

                let storeInfo = StoreInfoModel.init(name: store.name,
                                                    deliveryTime: store.deliveryTime)
                let deliveryInfoModel = DeilveryInfoModel.init(locationImage: "https://github.com/boostcamp3-iOS/team-b1/blob/master/images/FoodMarket/airInTheCafe.jpeg?raw=true",
                                                               detailedAddress: "메리츠 타워",
                                                               address: "서울특별시 강남구 역삼1동 강남대로 382",
                                                               deliveryMethod: .pickUpOutside,
                                                               roomNumber: 101,
                                                               deliveryTime: store.deliveryTime)

                let cartModel = CartModel.init(storeInfo: storeInfo,
                                               deilveryInfo: deliveryInfoModel,
                                               foodOrderedInfo: nil)

                cartViewController.cartModel = cartModel
                cartViewController.orderInfoModels = [OrderInfoModel.init(amount: 1,
                                                                          orderName: selectedFood.foodName,
                                                                          price: selectedFood.basePrice)]

                //            self.present(cartViewController, animated: true, completion: nil)
                self.navigationController?.pushViewController(cartViewController, animated: true)
            }
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

            let likeButtonImage = UIImage(named: getLikeButtonImageName(scrollView.contentOffset.y))

            self.likeButton.setImage(likeButtonImage, for: .normal)

            if scrollView.contentOffset.y > AnimationValues.scrollLimit
                && backButton.currentImage == UIImage(named: "arrow") {

                self.collectionView.contentInset = UIEdgeInsets(top: storeTitleView.frame.height - 30,
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

        floatingViewWidthConstraint.constant = estimatedForm.width + ValuesForFloatingView.widthPadding + 20

        floatingViewLeadingConstraint.constant = cell.frame.minX

        UIView.animate(withDuration: AnimationValues.duration,
                       delay: AnimationValues.delay,
                       options: .curveEaseOut,
                       animations: {
                        self.menuBarCollectionView.layoutIfNeeded()
        }, completion: nil)

        cell.setColor(by: true)

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

            return .init(width: estimatedForm.width + ValuesForFloatingView.widthPadding + 20,
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
