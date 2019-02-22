//
//  FoodService.swift
//  ServiceInterface
//
//  Created by 이혜주 on 17/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public protocol FoodsService: class {
    func requestFoods(storeId: String,
                      completionHandler: @escaping (DataResponse<FoodsForNetwork>) -> Void)

    func requestFoods(storeId: String,
                      dispatchQueue: DispatchQueue?,
                      completionHandler: @escaping (DataResponse<FoodsForNetwork>) -> Void)
}
