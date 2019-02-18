//
//  BusinessFoods.swift
//  ServiceInterface
//
//  Created by 이혜주 on 17/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public struct BusinessFoods {
    public let foods: [Food]

    public init(_ foods: [Food]) {
        self.foods = foods
    }
}
