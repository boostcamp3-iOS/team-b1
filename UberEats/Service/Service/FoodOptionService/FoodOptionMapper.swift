//
//  FoodOptionMapper.swift
//  Service
//
//  Created by 장공의 on 23/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

class FoodOptionMapper {
    
    static func from(foodOption: FoodOptionsForNetwork) -> FoodOptionsForView {
        
        let requiredOptionsModel = foodOption.requiredOptions
            .map { (requiredOption) -> RequiredOptionsModel in
           
                let options = requiredOption.optionItems.map {
                    (optionItem) -> CheckBoxModel in
                    
                     return CheckBoxModel(name: optionItem.name, price: optionItem.price)
                }
                
                return RequiredOptionsModel(foodOptionItems: options,
                                            name: requiredOption.name,
                                            supportingExplanation: requiredOption.supportingExplanation)
        }
    
         return FoodOptionsForView(requiredOptionsModel: requiredOptionsModel)
    }
    
}
