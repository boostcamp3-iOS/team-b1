//
//  CartViewController.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    fileprivate var cartItems: [[CartItemModelType]] =
        [[CartItemModelType]](repeating: [], count: CartSection.allCases.count)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: OrderButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storeInfo = StoreInfoModel(name: "배스킨라빈스 신천역점 Basikin  Robbins",
                                       deliveryTime: "20 - 30")

        let deilveryInfo = DeilveryInfoModel(locationImage: "asdasdasd",
                                             detailedAddress: "116-11",
                                             address: "서울특별시 송파구 방이동",
                                             deliveryMethod: .pickUpOutside,
                                             roomNumber: 303)

        let foodOrderedInfo = FoodsOrderedByOthersInfoModel()

        for _ in 1...2 {
            let pancakeOrder = OrderInfoModel(amount: 1,
                                              orderName: "딸기 수플래 팬케이크 Strawberry Souffle Pancake",
                                              price: 17000)

            let waffleOrder = OrderInfoModel(amount: 2,
                                             orderName: "홍콩 에그와플 Hongkong Egg Waffle",
                                             price: 13000)

            cartItems[CartSection.order.rawValue].append(
                CartItemModelType.order(pancakeOrder)
            )
            cartItems[CartSection.order.rawValue].append(
                CartItemModelType.order(waffleOrder)
            )
        }

        cartItems[CartSection.storeInfo.rawValue].append(
            CartItemModelType.storeInfo(storeInfo)
        )
        cartItems[CartSection.deliveryAddress.rawValue].append(
            CartItemModelType.deliveryInfo(deilveryInfo)
        )
        cartItems[CartSection.foodsOrderedByOthers.rawValue].append(
            CartItemModelType.foodsOrderedByOthersInfo(foodOrderedInfo)
        )
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

    @IBAction func clickedExitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

private enum CartItemModelType {
    case storeInfo(StoreInfoModel)
    case deliveryInfo(DeilveryInfoModel)
    case foodsOrderedByOthersInfo(FoodsOrderedByOthersInfoModel)
    case orderBookTitleInfo()
    case order(OrderInfoModel)
    case memo
    case priceInfo
    case paymentInfo
    case empty
}

private enum CartSection: Int, CaseIterable {

    case storeInfo = 0
    case deliveryAddress
    case foodsOrderedByOthers
    case orderBookTitle
    case order
    case memo
    case priceInfo
    case paymentInfo
    case empty

    var identifier: String {
        switch self {
        case .storeInfo:
            return "storeInfoCell"
        case .deliveryAddress:
            return "deliveryAddressCell"
        case .foodsOrderedByOthers:
            return "foodsOrderedByOthersCell"
        case .orderBookTitle:
            return "orderBookTitleCell"
        case .order:
            return "orderCell"
        case .memo:
            return "memoCell"
        case .priceInfo:
            return "priceInfoCell"
        case .paymentInfo:
            return "paymentInfoCell"
        case .empty:
            return "emptyCell"
        }

    }

}
