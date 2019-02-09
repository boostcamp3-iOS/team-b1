//
//  Service.swift
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public protocol Network {
    
}

public enum ServiceFactory: Service {
    
    public static func createFoodMarketService(network: Network) -> FoodMarketService {
        
        return FoodMarketServiceImp(network: network)
    }
    
}
