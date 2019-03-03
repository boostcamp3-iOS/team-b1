//
//  CartViewController.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: OrderButton!

    fileprivate var cartItems = [[CartItemModelType]](repeating: [],
                                                      count: CartSection.allCases.count)

    var storeImageURL: String?
    var cartModel: CartModel = CartModel.empty() {
        didSet {
            setUpCartModel()
            tableView?.reloadData()
        }
    }

    var orderInfoModels: [OrderInfoModel] = [OrderInfoModel]() {
        didSet {
            setUpOrderInfo(orderInfoModels)
            setUpPriceInfo(orderInfoModels)
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        orderButton.orderButtonClickable = self
        orderButton.orderButtonText = "주문하기"
        orderButton.orderInfos = orderInfoModels
        tableView.reloadData()
    }

    @IBAction func clickedExitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    private func setUpCartModel() {

        cartItems[CartSection.storeInfo.rawValue].append(
            CartItemModelType.storeInfo(cartModel.storeInfo)
        )
        cartItems[CartSection.deliveryAddress.rawValue].append(
            CartItemModelType.deliveryInfo(cartModel.deilveryInfo)
        )

        if let foodOrderedInfo = cartModel.foodOrderedInfo {
            cartItems[CartSection.foodsOrderedByOthers.rawValue].append(
                CartItemModelType.foodsOrderedByOthersInfo(foodOrderedInfo)
            )
        }

        cartItems[CartSection.orderBookTitle.rawValue].append(
            CartItemModelType.orderBookTitleInfo()
        )

        cartItems[CartSection.memo.rawValue].append(
            CartItemModelType.memo
        )

        cartItems[CartSection.priceInfo.rawValue].append(
            CartItemModelType.priceInfo(PriceInfoModel.empty())
        )

        cartItems[CartSection.paymentInfo.rawValue].append(
            CartItemModelType.paymentInfo
        )

        cartItems[CartSection.empty.rawValue].append(
            CartItemModelType.empty
        )
    }

    private func setUpOrderInfo(_ orderInfoModels: [OrderInfoModel]) {
        cartItems[CartSection.order.rawValue] = orderInfoModels.map({
            CartItemModelType.order($0)
        })

        orderButton?.orderInfos = orderInfoModels
    }

    private func setUpPriceInfo(_ orderInfoModels: [OrderInfoModel]) {
        cartItems[CartSection.priceInfo.rawValue].removeAll()
        cartItems[CartSection.priceInfo.rawValue].append(
            CartItemModelType.priceInfo(PriceInfoModel(orderInfoModels))
        )
    }

}

extension CartViewController: OrderButtonClickable {

    func onClickedOrderButton(_ sender: Any) {

        let storyboard = UIStoryboard.init(name: "LocationViewController", bundle: nil)
        guard let deliveryStartVC = storyboard.instantiateViewController(withIdentifier: "locationViewController")
            as? LocationViewController else {
            return
        }

        let delivererInfo = DelivererInfo.init(name: "중현",
                                               rate: 100,
                                               image: UIImage(named: "deliverer"),
                                               vehicle: "motorbike",
                                               phoneNumber: "01020313421",
                                               email: "delivery@gmail.com")

        deliveryStartVC.locationInfoDataSource = LocationInfoDataSourece(storeName: cartModel.storeInfo.name,
                                                                         orders: orderInfoModels,
                                                                         delivererInfo: delivererInfo,
                                                                         locationViewController: deliveryStartVC)

        deliveryStartVC.storeLocationInfo = cartModel.storeInfo.location
        deliveryStartVC.storeImageURL = storeImageURL

        self.navigationController?.pushViewController(deliveryStartVC, animated: true)
    }

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cartSection = CartSection(rawValue: indexPath.section) else {
            fatalError("failed casting CartSection")
        }

        let itemModel = cartItems[indexPath.section][indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cartSection.identifier,
                                                 for: indexPath)

        switch itemModel {
        case .storeInfo(let storeInfo):
            (cell as! StoreInfoCell).storeInfo = storeInfo
            return cell
        case .deliveryInfo(let deilveryInfo):
            (cell as! DeliveryAddressCell).deilveryInfo = deilveryInfo
            return cell
        case .foodsOrderedByOthersInfo(let foodsOrderedInfo):
            _ = foodsOrderedInfo
            return cell
        case .orderBookTitleInfo:
            return cell
        case .order(let orderInfo):
            (cell as! OrderCell).order = orderInfo
            return cell
        case .priceInfo(let priceInfo):
            (cell as! PriceInfoCell).priceInfo = priceInfo
            return cell
        case .memo, .paymentInfo, .empty:
            return cell
        }
    }

}
