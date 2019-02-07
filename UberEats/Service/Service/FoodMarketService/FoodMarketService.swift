//
//  FoodMarketService.swift
//  Service
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public protocol FoodMarketService: class {
    func requestFoodMarket(completionHandler: @escaping (DataResponse<FoodMarket>) -> Void)
    
    func requestFoodMarket(dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<FoodMarket>) -> Void )
}
