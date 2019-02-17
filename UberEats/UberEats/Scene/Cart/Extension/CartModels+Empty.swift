//
//  CartViewModel+Empty.swift
//  UberEats
//
//  Created by 장공의 on 17/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension CartModel {

    static func empty() -> CartModel {
        let storeInfo = StoreInfoModel(name: "",
                                       deliveryTime: "")

        let deilveryInfo = DeilveryInfoModel(locationImage: "",
                                             detailedAddress: "",
                                             address: "",
                                             deliveryMethod: .pickUpOutside,
                                             roomNumber: 0)

        return CartModel(storeInfo: storeInfo,
                             deilveryInfo: deilveryInfo,
                             foodOrderedInfo: nil)
    }
}

extension PriceInfoModel {
    static func empty() -> PriceInfoModel {
        return PriceInfoModel(0)
    }
}
