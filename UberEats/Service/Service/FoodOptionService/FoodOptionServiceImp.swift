//
//  FoodOptionService.swift
//  Service
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import ServiceInterface
import Common

internal class FoodOptionServiceImp: FoodOptionService {
    
    func requestFoodOptions(foodId: String,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        
    }
    
    func requestFoodOptions(foodId: String,
                            dispatchQueue: DispatchQueue,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        dispatchQueue.async { [weak self] in
            self?.requestFoodOptions(foodId: foodId, completionHandler: completionHandler)
        }
    }
}
