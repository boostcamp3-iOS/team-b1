//
//  FoodOptionService.swift
//  ServiceInterface
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public protocol FoodOptionService: class {
    func requestFoodOptions(foodId: String,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void)

    func requestFoodOptions(foodId: String,
                            dispatchQueue: DispatchQueue,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void)
}
