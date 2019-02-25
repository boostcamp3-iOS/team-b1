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

    var storeId: String?
    var foodId: String?

    var orderFoods: [OrderInfoModel] = []
    var totalPrice = 0
    var store: StoreForView?
    var foods: [FoodForView] = []
    var categorys: [String] = []
    var foodsOfCategory: [String: [FoodForView]] = [:]

    var statusBarStyle: UIStatusBarStyle = .lightContent
    var lastSection: Int = 3
    private let padding: CGFloat = 5

    var isLiked: Bool = false
    var isScrolling: Bool = false
    var isChangedSection: Bool = false

    var identifier = ""

    var floatingViewLeadingConstraint = NSLayoutConstraint()
    var floatingViewWidthConstraint = NSLayoutConstraint()

    let floatingView = FloatingView()
    var storeTitleView = StoreTitleView()
    let backButton = UIButton().initButtonWithImage("arrow")
    let likeButton = UIButton().initButtonWithImage("like")

    private var storeService: StoreService = DependencyContainer.share.getDependency(key: .storeService)
    private var foodsService: FoodsService = DependencyContainer.share.getDependency(key: .foodsService)

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

    lazy var menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ValuesForCollectionView.menuBarMinSpacing

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.9700)
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

        storeService.requestStore(storeId: storeId, dispatchQueue: .global()) { [weak self] (response) in
            guard response.isSuccess,
                let store = response.value?.store else {
                return
            }
            self?.storeTitleView.store = store
            self?.store = store

            self?.foodsService.requestFoods(storeId: storeId, dispatchQueue: .global()) { [weak self] (response) in
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
        menuBarCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredVertically)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        // header
        collectionView.register(StretchyHeaderView.self,
                                forSupplementaryViewOfKind: ElementKind.sectionHeader,
                                withReuseIdentifier: CellId.stretchyHeader.rawValue)

        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: ElementKind.sectionHeader,
                                withReuseIdentifier: CellId.tempHeader.rawValue)

        menuBarCollectionView.register(TempCollectionReusableView.self,
                                       forSupplementaryViewOfKind: ElementKind.sectionHeader,
                                       withReuseIdentifier: CellId.tempHeader.rawValue)

        // footer
        collectionView.register(TempCollectionReusableView.self,
                                forSupplementaryViewOfKind: ElementKind.sectionFooter,
                                withReuseIdentifier: CellId.tempFooter.rawValue)

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
            floatingView.centerYAnchor.constraint(equalTo: menuBarCollectionView.centerYAnchor),
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
            let foodOptionStoryboard = UIStoryboard(name: "FoodItemDetails", bundle: nil)
            guard let foodOptionViewController = foodOptionStoryboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")
                as? FoodItemDetailsViewController else {
                    return
            }

            var selectedFood: FoodForView?

            foods.forEach {
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

}

extension StoreCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuBarCollectionView {
            let estimatedForm = categorys[indexPath.item].estimateCGRect

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
                let foodsIndex = indexPath.item - DistanceBetween.titleAndFoodCell

                if foods[foodsIndex].foodDescription == ""
                    && foods[foodsIndex].foodImageURL != "" {
                    return .init(width: view.frame.width - 2 * padding, height: HeightsOfCell.foodWhenNoContentAndImage)
                } else if foods[foodsIndex].foodDescription == ""
                    && foods[foodsIndex].foodImageURL == "" {
                    return .init(width: view.frame.width - 2 * padding, height: HeightsOfCell.foodWhenNoContentAndNoImage)
                } else {
                    let commentString: String = foods[foodsIndex].foodDescription + "\n" +
                        foods[indexPath.item - DistanceBetween.titleAndFoodCell].foodName + "\n" +
                        String(foods[indexPath.item - DistanceBetween.titleAndFoodCell].basePrice) + "\n"

                    return .init(width: view.frame.width - 2 * padding, height: commentString.estimateCGRect.height + 45)
                }
            }
            return .init(width: view.frame.width - 2 * padding, height: HeightsOfCell.food)
        }
    }
}
