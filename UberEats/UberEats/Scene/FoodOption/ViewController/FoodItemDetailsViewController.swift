//
//  FoodItemDetailsViewController.swift
//  UberEats
//
//  Created by 장공의 on 27/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import DependencyContainer
import ServiceInterface
import Common

class FoodItemDetailsViewController: UIViewController, QuantityValueChanged {

    @IBOutlet weak var toolbar: UIView!

    @IBOutlet weak var coverToolBar: UIView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var stretchableHeaderHeight: NSLayoutConstraint!

    @IBOutlet weak var coveredToolBarBottom: NSLayoutConstraint!

    private var style: UIStatusBarStyle = .lightContent

    @IBOutlet weak var coverToolBarText: UILabel!

    @IBOutlet weak var orderButton: OrderButton!

    fileprivate var foodOptionItemModels = [[FoodOptionItemModelType]]()

    @IBOutlet weak var foodImage: UIImageView!

    private let foodOptionService: FoodOptionService = DependencyContainer.share.getDependency(key: .foodOptionService)

    var foodInfo: FoodInfoModel? {
        didSet {
            guard let foodInfo = foodInfo else {
                return
            }
            setUpFoodInfoModel(foodInfo: foodInfo)
        }
    }

    fileprivate var requiredOptions: [RequiredOptionsModel]? {
        didSet {
            guard let requiredOptions = requiredOptions,
                let _ = foodInfo else {
                return
            }
            setUpRequiredOptions(requiredOptions: requiredOptions)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        self.coveredToolBarBottom.constant = -toolbar.frame.height

        // 리펙토링할 것 급한 이유로 우선 개발
        func getHeaderHight() -> CGFloat {

            if (foodInfo?.imageURL == "") {
                foodImage.isHidden = true
                return coverToolBar.frame.height / 2
            } else {

                guard let url = URL(string: foodInfo!.imageURL) else {
                    return FoodDetailDimensions.stretchableHeaderImageHeight
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: url) { (image, _) in

                    guard let image = image  else {
                        fatalError()
                    }

                    self.foodImage?.image = image

                }
                return FoodDetailDimensions.stretchableHeaderImageHeight
            }

        }

        tableView.contentInset = UIEdgeInsets(top: getHeaderHight(),
                                              left: 0,
                                              bottom: 0,
                                              right: 0)

        tableView.rowHeight = UITableView.automaticDimension
        orderButton.layer.cornerRadius = FoodDetailDimensions.orderButtonCornerRadius
        loadData()
    }

    private func loadData() {
        foodOptionService.requestFoodOptions(foodId: "A", dispatchQueue: .global()) { [weak self] (dataResponse) in
                guard dataResponse.isSuccess,
                    let value = dataResponse.value else {
                    return
                }

            self?.requiredOptions = value.requiredOptionsModel

            self?.foodOptionItemModels.append([FoodOptionItemModelType.specialRequests()])
            self?.foodOptionItemModels.append([FoodOptionItemModelType.memo()])
            self?.foodOptionItemModels.append([FoodOptionItemModelType.quantityControl()])
            self?.foodOptionItemModels.append([FoodOptionItemModelType.empty()])

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func quantityValueChanged(newQuantity: Int) {
        orderButton?.orderButtonText = "카트에 \(newQuantity) 추가"
    }

    @IBAction func clickedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickedCartButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartViewController
        self.navigationController?.pushViewController(cartViewController, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }

}

extension FoodItemDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    fileprivate func setUpRequiredOptions(requiredOptions: [RequiredOptionsModel]) {
        requiredOptions.forEach { (requiredOptionsModel) in

            var foodOptions = [FoodOptionItemModelType]()
            foodOptions.append(.requiredOptions(requiredOptionsModel))

            requiredOptionsModel.foodOptionItems.forEach({
                foodOptions.append(.optionItem($0))
            })

            foodOptionItemModels.append(foodOptions)
        }
    }

    fileprivate func setUpFoodInfoModel(foodInfo: FoodInfoModel) {
        var foodOptions = [FoodOptionItemModelType]()
        foodOptions.append(FoodOptionItemModelType.foodInfo(foodInfo))
        foodOptionItemModels.append(foodOptions)
        coverToolBarText?.text = foodInfo.name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodOptionItemModels[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = foodOptionItemModels[indexPath.section][indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier,
                                                 for: indexPath)

        func setUpFoodOptionCategoryModel(_ cell: UITableViewCell, _ model: FoodOptionsCategory) {
            if let cell = cell as? HavingFoodOptionCategory {
                cell.foodOptionCategoryModel = model
            }
        }

        switch model {
        case .foodInfo(let model):
            setUpFoodOptionCategoryModel(cell, model)

        case .requiredOptions(let model):
            setUpFoodOptionCategoryModel(cell, model)

        case .additionalOptions(let model):
            setUpFoodOptionCategoryModel(cell, model)

        case .optionItem(let model):
            guard let cell = cell as? HavingFoodOptionItem else {
                preconditionFailure("casting failed : HavingFoodOptionItem")
            }
            cell.foodOptionItemModel = model
        case .quantityControl:
            guard let cell = cell as? QuantityCell else {
                preconditionFailure("casting failed : QuantityCell")
            }

            cell.quantitychanged = self
        default:
            return cell
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return foodOptionItemModels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
