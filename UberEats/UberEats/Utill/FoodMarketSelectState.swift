//
//  FoodMarketSelectState.swift
//  UberEats
//
//  Created by admin on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

enum SelectState {
    case store(String)
    case food(foodId: String, storeId: String)
}
