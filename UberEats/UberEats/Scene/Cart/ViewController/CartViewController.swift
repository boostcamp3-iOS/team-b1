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

    fileprivate var cartItems: [[CartItemModelType]] =
        [[CartItemModelType]](repeating: [], count: CartSection.allCases.count)

    var cartModel: CartModel = CartModel.empty() {
        didSet {
            setUpCartModel()
        }
    }

    var orderInfoModels: [OrderInfoModel] = [OrderInfoModel]() {
        didSet {
            cartItems[CartSection.order.rawValue] = orderInfoModels.map({
                CartItemModelType.order($0)
            })
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDummy()
        orderButton.orderButtonClickable = self

    }

    private func setUpDummy() {
        cartModel = CartModel.empty()
        let pancakeOrder = OrderInfoModel(amount: 1,
                                          orderName: "딸기 수플래 팬케이크 Strawberry Souffle Pancake",
                                          price: 17000)

        orderInfoModels.append(pancakeOrder)
    }

    @IBAction func clickedExitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            CartItemModelType.priceInfo
        )

        cartItems[CartSection.paymentInfo.rawValue].append(
            CartItemModelType.paymentInfo
        )

        cartItems[CartSection.empty.rawValue].append(
            CartItemModelType.empty
        )
    }
}

extension CartViewController: OrderButtonClickable {

    func onClickedOrderButton(_ sender: Any) {
        // TO DO
        _ = ""
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
        case .memo, .priceInfo, .paymentInfo, .empty:
            return cell
        }
    }

}
