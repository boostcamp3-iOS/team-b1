//
//  FoodMarketServiceImp.swift
//  Service
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common
import ServiceInterface

internal class FoodMarketServiceImp: FoodMarketService {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func requestFoodMarket(completionHandler: @escaping (DataResponse<FoodMarket>) -> Void) {
        
        let requestURL = URL(string: "www.uberEats.com/foodMarket")!
        
        network.request(with: requestURL) { ( data, response, _) in
            
            if response?.httpStatusCode == .ok {
                
                guard let data = data else {
                    return
                }
                
                do {
                    let foodMarket: FoodMarket = try JSONDecoder().decode(FoodMarket.self, from: data)
                    completionHandler(DataResponse.success(foodMarket))
                } catch {
                    fatalError()
                }
        
            } else {
                fatalError()
            }
            
        }
        
    }
    
    func requestFoodMarket(dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<FoodMarket>) -> Void) {
        dispatchQueue?.async {
            self.requestFoodMarket(completionHandler: completionHandler)
        }
    }
    
}
