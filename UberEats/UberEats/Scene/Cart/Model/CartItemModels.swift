//
//  CartTableViewCellModels.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

struct StoreInfoModel {
    let name: String
    let deliveryTime: String
}

struct DeilveryInfoModel {
    let locationImage: String
    let detailedAddress: String
    let address: String
    let deliveryMethod: DeliveryMethod
    let roomNumber: Int
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
