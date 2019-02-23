//
//  FoodOptionMockServiceImp.swift
//  Service
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

import UIKit
import ServiceInterface
import Common

internal class FoodOptionMockServiceImp: FoodOptionService {
    
    init(network: Network) { }
    
    func requestFoodOptions(foodId: String,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        
        var requiredOptionsModels = [RequiredOptionsModel]()
        
        for _ in 1..<5 {
            var foodOptionItems = [FoodOptionItem]()
            foodOptionItems.append(CheckBoxModel(name: "", price: 1200))
            foodOptionItems.append(CheckBoxModel(name: "", price: 5000))
            foodOptionItems.append(CheckBoxModel(name: "", price: 9000))
            
            requiredOptionsModels.append(
                RequiredOptionsModel(foodOptionItems: foodOptionItems,
                                     name: "",
                                     supportingExplanation: " d")
            )
        }
        
        let result = FoodOptionsForView(foodInfoModel: FoodInfoModel(name: "",
                                                                     supportingExplanation: "",
                                                                     price: 0,
                                                                     imageURL: ""),
                                        requiredOptionsModel: requiredOptionsModels)
        
        DispatchQueue.main.async {
            completionHandler(DataResponse.success(result))
        }
        
    }
    
    func requestFoodOptions(foodId: String,
                            dispatchQueue: DispatchQueue,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        dispatchQueue.async { [weak self] in
            self?.requestFoodOptions(foodId: foodId, completionHandler: completionHandler)
        }
    }
}
