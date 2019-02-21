//
//  BusinessFoods.swift
//  Common
//
//  Created by 이혜주 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct FoodsForNetwork {
    public let foods: [FoodForView]

    public init(_ foods: [FoodForView]) {
        self.foods = foods
    }
}
