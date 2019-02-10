//
//  LocationModel.swift
//  UberEats
//
//  Created by 이혜주 on 08/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

enum SectionName: Int {
    case timeDetail = 0
    case orders
    case sale
}

struct Identifiers {
    static let arrivalTimeHeaderId: String = "orderChecking"
    static let orderNameHeaderId: String = "orderName"
    static let separatorHeaderId: String = "separator"
    static let tempHeaderId: String = "tempHeader"

    static let separatorFooterId: String = "separator"
    static let totalPriceFooterId: String = "totalPrice"
    static let tempFooterId: String = "tempFooter"

    static let orderCancelCellId: String = "orderCancel"
    static let orderMenuCellId: String = "orderedMenu"
    static let emptyCellId: String = "emptyCell"
}
