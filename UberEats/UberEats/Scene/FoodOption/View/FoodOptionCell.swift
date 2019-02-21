//
//  JobOptionCell.swift
//  UberEats
//
//  Created by 장공의 on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

protocol HavingFoodOptionCategory: class {
    var foodOptionCategoryModel: FoodOptionsCategory! { get set }
}

protocol HavingFoodOptionItem: class {
    var foodOptionItemModel: FoodOptionItem! { get set }
}
