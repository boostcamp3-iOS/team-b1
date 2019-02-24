//
//  CartTableViewCellModels.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

struct CartModel {
    let storeInfo: StoreInfoModel
    let deilveryInfo: DeilveryInfoModel
    let foodOrderedInfo: FoodsOrderedByOthersInfoModel?
}

struct StoreInfoModel {
    let name: String
    let deliveryTime: String
    let location: Location
}

struct DeilveryInfoModel {
    let locationImage: String
    let detailedAddress: String
    let address: String
    let deliveryMethod: DeliveryMethod
    let roomNumber: Int
}

struct PriceInfoModel {
    let price: Int
    let subPrice: Int

    init(_ price: Int) {
        self.price = price
        self.subPrice = price
    }

    init(_ orderInfos: [OrderInfoModel], _ subPrice: Int? = nil) {
        let amount = orderInfos.map({ $0.price * $0.amount })
            .reduce(0) { $0 + $1 }
        self.price = amount

        guard let subPrice = subPrice else {
            self.subPrice = amount
            return
        }

        self.subPrice = subPrice
    }
}

struct FoodsOrderedByOthersInfoModel {

}

struct OrderInfoModel {
    let amount: Int
    let orderName: String
    let price: Int
}

enum DeliveryMethod {
    case deliveryToDoor
    case pickUpOutside
}

enum CartItemModelType {
    case storeInfo(StoreInfoModel)
    case deliveryInfo(DeilveryInfoModel)
    case foodsOrderedByOthersInfo(FoodsOrderedByOthersInfoModel)
    case orderBookTitleInfo()
    case order(OrderInfoModel)
    case memo
    case priceInfo(PriceInfoModel)
    case paymentInfo
    case empty
}

enum CartSection: Int, CaseIterable {

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
