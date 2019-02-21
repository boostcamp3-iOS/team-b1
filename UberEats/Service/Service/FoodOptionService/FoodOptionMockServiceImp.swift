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
    
    init(network: Network) {
        
    }
    
    func requestFoodOptions(foodId: String, completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        
        var requiredOptionsModels = [RequiredOptionsModel]()
        
        for _ in 1..<5 {
            var foodOptionItems = [FoodOptionItem]()
            foodOptionItems.append(CheckBoxModel(name: "소고기", price: 1200))
            foodOptionItems.append(CheckBoxModel(name: "비둘비둘", price: 5000))
            foodOptionItems.append(CheckBoxModel(name: "양고기", price: 9000))
            
            requiredOptionsModels.append(
                RequiredOptionsModel(foodOptionItems: foodOptionItems,
                                     name: "패티 선택",
                                     supportingExplanation: "1까지 선택")
            )
        }
        
        let foodInfo = FoodInfoModel(name: "치즈 와퍼 주니어 세트 Cheese Whopper Jr Meal", supportingExplanation: "불에 직접 구운 순 쇠고기 패티가 들어간 와퍼주니어에 고소한 치즈 추기!")
        
        let result = FoodOptionsForView(foodInfoModel: foodInfo,
                           requiredOptionsModel: requiredOptionsModels)
        
        DispatchQueue.main.async {
            completionHandler(DataResponse.success(result))
        }
        
    }
    
    func requestFoodOptions(foodId: String, dispatchQueue: DispatchQueue, completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        dispatchQueue.async {
            self.requestFoodOptions(foodId: foodId, completionHandler: completionHandler)
        }
    }
    
}
