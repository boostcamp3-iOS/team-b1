//
//  FoodsServiceImp.swift
//  Service
//
//  Created by 이혜주 on 17/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common
import ServiceInterface

class FoodsServiceImp: FoodsService {

    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func requestFoods(storeId: String, completionHandler: @escaping (DataResponse<FoodsForNetwork>) -> Void) {
        guard let requestURL = URL(string: "www.uberEats.com/foods?" + storeId) else {
            fatalError("URL conversion error")
        }
        
        network.request(with: requestURL) { (data, response, _) in
            if response?.httpStatusCode == .ok {
                
                guard let data = data else {
                    return
                }
                
                do {
                    let foods: [FoodForView] = try JSONDecoder().decode([FoodForView].self, from: data)
                    
                    let caculatedFoods = FoodsForNetwork(foods)
                    
                    DispatchQueue.main.async {
                        completionHandler(DataResponse.success(caculatedFoods))
                    }
                } catch {
                    fatalError("decoding Error")
                }
            } else {
                fatalError()
            }
        }
    }
    
    func requestFoods(storeId: String, dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<FoodsForNetwork>) -> Void) {
        dispatchQueue?.async {
            self.requestFoods(storeId: storeId, completionHandler: completionHandler)
        }
    }
    
}
