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

    private var totalPrice = 0
    private var orderFoods: [OrderInfoModel] = []
    private var storeService: StoreService = DependencyContainer.share.getDependency(key: .storeService)
    private var foodsService: FoodsService = DependencyContainer.share.getDependency(key: .foodsService)

    private let padding: CGFloat = 5

    var storeId: String?
    var foodId: String?
    var statusBarStyle: UIStatusBarStyle = .lightContent
    var lastSection: Int = 3
    var isLiked: Bool = false
    var isScrolling: Bool = false
    var isChangedSection: Bool = false
    var floatingViewLeadingConstraint = NSLayoutConstraint()
    var floatingViewWidthConstraint = NSLayoutConstraint()
    var storeTitleView = StoreTitleView()
    lazy var floatingView = FloatingView()

    let backButton = UIButton().initButtonWithImage("arrow")
    let likeButton = UIButton().initButtonWithImage("like")

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    lazy var moveCartView: MoveCartView = {
        let view = MoveCartView()
        view.moveCartButton.orderButtonClickable = self
        view.isHidden = true
        return view
    }()

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

    var menuBarDataSource: MenuCollectionViewDataSource? {
        didSet {
            menuBarCollectionView.reloadData()
        }
    }

    var mainCollectionViewDataSource: MainCollectionViewDataSource? {
        didSet {
            collectionView.reloadData()
        }
    }

    lazy var menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ValuesForCollectionView.menuBarMinSpacing

        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: layout)
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.9700)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
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
        collectionView.dataSource = mainCollectionViewDataSource
    }

    func passingData(status: SelectState) {
        switch status {
        case .store(let storeId):
            self.storeId = storeId
        case .food(foodId: let foodId, storeId: let storeId):
            self.storeId = storeId
            self.foodId = foodId
        }
    }

    // MARK: - Method
    private func setupData() {
        dataIndicator.startAnimating()
        collectionView.isScrollEnabled = false

        guard let storeId = storeId else {
            return
        }

        storeService.requestStore(storeId: storeId,
                                  dispatchQueue: .global()) { [weak self] (response) in
            guard response.isSuccess,
                let store = response.value?.store else {
                    return
            }

            self?.storeTitleView.configure(store: store)

            self?.foodsService.requestFoods(storeId: storeId,
                                            dispatchQueue: .global()) { [weak self] (response) in
                guard response.isSuccess,
                    let foods = response.value?.foods else {
                        return
                }

                let info: (foods: [String], categories: [String: [FoodForView]]) = seperateCategory(foods: foods)

                self?.menuBarDataSource = MenuCollectionViewDataSource(categorys: info.foods)
                self?.menuBarCollectionView.dataSource = self?.menuBarDataSource

                self?.mainCollectionViewDataSource = MainCollectionViewDataSource(store: store,
                                                                                  foods: foods,
                                                                                  categorys: info.foods,
                                                                                  categoryOfFood: info.categories)
                self?.collectionView.dataSource = self?.mainCollectionViewDataSource

                self?.setupFloatingView()
                self?.setupCollectionView()
                self?.pushFoodDetail()
                self?.dataIndicator.stopAnimating()
                self?.collectionView.isScrollEnabled = true
            }
        }
    }

    private func setupLayout() {
        storeTitleView = StoreTitleView(view)

        collectionView.addSubview(storeTitleView)
        collectionView.addSubview(dataIndicator)
        view.addSubview(backButton)
        view.addSubview(likeButton)
        view.addSubview(menuBarCollectionView)
        view.addSubview(moveCartView)
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
            likeButton.heightAnchor.constraint(equalToConstant: buttonSize),

            moveCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moveCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moveCartView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moveCartView.heightAnchor.constraint(equalToConstant: 85)
            ])
    }

    private func setupCollectionView() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexPath,
                                         animated: false,
                                         scrollPosition: .centeredVertically)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        // header
        collectionView.register(StretchyHeaderView.self, kind: ElementKind.sectionHeader)

        collectionView.register(TempCollectionReusableView.self, kind: ElementKind.sectionHeader)

        menuBarCollectionView.register(TempCollectionReusableView.self, kind: ElementKind.sectionHeader)

        // footer
        collectionView.register(TempCollectionReusableView.self, kind: ElementKind.sectionFooter)

        // cell
        collectionView.register(FoodCollectionViewCell.self)

        let timeAndLocationNib = UINib(nibName: XibName.timeAndLocation.rawValue, bundle: nil)
        collectionView.register(nib: timeAndLocationNib, TimeAndLocationCollectionViewCell.self)

        let menuNib = UINib(nibName: XibName.search.rawValue, bundle: nil)
        collectionView.register(nib: menuNib, SearchCollectionViewCell.self)

        let menuCategoryNib = UINib(nibName: XibName.menuCategory.rawValue, bundle: nil)
        menuBarCollectionView.register(nib: menuCategoryNib, MenuCategoryCollectionViewCell.self)

        let menuSectionNib = UINib(nibName: XibName.menuSection.rawValue, bundle: nil)
        collectionView.register(nib: menuSectionNib, MenuSectionCollectionViewCell.self)

    }

    private func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? StretchyHeaderLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }

    private func setupFloatingView() {
        guard let category = menuBarDataSource?.categorys[0] else {
            return
        }

        floatingViewWidthConstraint = NSLayoutConstraint(item: floatingView,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .width,
                                                            multiplier: ValuesForFloatingView.fullMultiplier,
                                                            constant: category.estimateCGRect.width
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
            floatingView.centerYAnchor.constraint(equalTo: menuBarCollectionView.centerYAnchor),
            floatingView.heightAnchor.constraint(equalToConstant: ValuesForFloatingView.heightConstant)
            ])
    }

    private func pushFoodDetail() {
        if foodId != nil {
            let foodOptionStoryboard = UIStoryboard(name: "FoodItemDetails", bundle: nil)
            guard let foodOptionViewController
                = foodOptionStoryboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")
                as? FoodItemDetailsViewController else {
                    return
            }

            var selectedFood: FoodForView?

            mainCollectionViewDataSource?.foods.forEach {
                if foodId == $0.id {
                    selectedFood = $0
                }
            }

            guard let food = selectedFood else {
                return
            }

            foodOptionViewController.foodSelectable = self

            foodOptionViewController.foodInfo = FoodInfoModel(name: food.foodName,
                                                              supportingExplanation: food.foodDescription,
                                                              price: food.basePrice,
                                                              imageURL: food.foodImageURL)

            navigationController?.pushViewController(foodOptionViewController, animated: true)
        }
    }

    // Object-C Method
    @objc private func touchUpBackButton(_: UIButton) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }

    @objc private func touchUpLikeButton(_ sender: UIButton) {
        let imageName = sender.currentImage == UIImage(named: "like") ? "selectLike" : "like"
        sender.setImage(UIImage(named: imageName), for: .normal)

        isLiked = !isLiked
    }
}

extension StoreCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuBarCollectionView {
            guard let estimatedForm
                = menuBarDataSource?.categorys[indexPath.item].estimateCGRect else {
                return .init()
            }

            return .init(width: estimatedForm.width + ValuesForFloatingView.widthPadding,
                         height: HeightsOfCell.menuBarAndMenu)
        }

        switch indexPath.section {
        case 0:
            return .init(width: view.frame.width - 2 * padding,
                         height: HeightsOfCell.empty)
        case 1:
            return .init(width: view.frame.width - 2 * padding,
                         height: view.frame.height * HeightsOfCell.timeAndLocationMultiplier)
        case 2:
            return .init(width: view.frame.width - 2 * padding,
                         height: HeightsOfCell.menuBarAndMenu)
        default:
            if indexPath.item != 0 {
                guard let foods
                    = mainCollectionViewDataSource?.categoryOfFood["category"
                                                                    + String(indexPath.section
                                                                    - DistanceBetween.menuAndRest + 1)] else {
                    return .init()
                }

                let foodsIndex = indexPath.item - DistanceBetween.titleAndFoodCell

                return CGSize(width: view.frame.width - 2 * padding,
                             height: getCellHeight(food: foods[foodsIndex]))

            }
            return .init(width: view.frame.width - 2 * padding,
                         height: HeightsOfCell.food)
        }
    }

}

extension StoreCollectionViewController: OrderButtonClickable {

    func onClickedOrderButton(_ sender: Any) {
        let cartStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        guard let cartViewController = cartStoryboard.instantiateViewController(withIdentifier: "CartVC")
            as? CartViewController else {
                return
        }

        guard let store = mainCollectionViewDataSource?.store else {
            return
        }

        let storeInfo = StoreInfoModel.init(name: store.name,
                                            deliveryTime: store.deliveryTime,
                                            location: store.location)

        let deliveryInfoModel = DeilveryInfoModel.init(locationImage: "",
                                                       detailedAddress: "서울특별시 강남구 역삼1동 강남대로 382",
                                                       address: "메리츠 타워",
                                                       deliveryMethod: .pickUpOutside,
                                                       roomNumber: 101)

        cartViewController.cartModel = CartModel.init(storeInfo: storeInfo,
                                                      deilveryInfo: deliveryInfoModel,
                                                      foodOrderedInfo: nil)

        cartViewController.orderInfoModels = orderFoods

        cartViewController.storeImageURL = store.lowImageURL

        navigationController?.pushViewController(cartViewController, animated: true)
    }

}

extension StoreCollectionViewController: FoodSelectable {

    func foodSelected(orderInfo: OrderInfoModel) {
        orderFoods.append(orderInfo)
        totalPrice += orderInfo.amount * orderInfo.price
        moveCartView.moveCartButton.setAmount(price: totalPrice)

        if !orderFoods.isEmpty {
            moveCartView.isHidden = false
        }
    }

}
