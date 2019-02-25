//
//  LocationModel.swift
//  UberEats
//
//  Created by 이혜주 on 08/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

enum SectionName: Int {
    case deliveryManInfo = 0
    case timeDetail
    case orders
    case sale
}

struct Identifiers {
    static let deliveryManInfoHeaderId: String = "deliveryManInfo"
    static let arrivalTimeHeaderId: String = "orderChecking"
    static let orderNameHeaderId: String = "orderName"
    static let separatorHeaderId: String = "separator"
    static let tempHeaderId: String = "tempHeader"

    static let separatorFooterId: String = "separator"
    static let totalPriceFooterId: String = "totalPrice"
    static let tempFooterId: String = "tempFooter"

    static let orderCancelCellId: String = "orderCancel"
    static let orderMenuCellId: String = "orderedMenu"
    static let saleCellId: String = "saleCell"
}

struct DelivererInfo {
    let name: String
    let rate: Int
    let image: UIImage?
    let vehicle: String
    let phoneNumber: String
    let email: String
}
