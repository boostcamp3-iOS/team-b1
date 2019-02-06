//
//  FoodMarketServiceImp.swift
//  Service
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

internal class FoodMarketServiceImp: FoodMarketService {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func requestFoodMarket(completionHandler: @escaping (DataResponse<FoodMarket>) -> Void) {
        
    }
    
    func requestFoodMarket(queue: DispatchQueue?, completionHandler: @escaping (DataResponse<FoodMarket>) -> Void) {
     
    }
    
}
