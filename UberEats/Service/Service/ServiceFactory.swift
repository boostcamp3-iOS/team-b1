//
//  Service.swift
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import ServiceInterface

public enum ServiceFactory {
   
    public static func createFoodMarketService(network: Network) -> FoodMarketService {
        return FoodMarketServiceImp(network: network)
    }
    
    public static func createStoreService(network: Network) -> StoreService {
        return StoreServiceImp(network: network)
    }
    
    public static func createFoodsService(network: Network) -> FoodsService {
        return FoodsServiceImp(network: network)
    }
}
