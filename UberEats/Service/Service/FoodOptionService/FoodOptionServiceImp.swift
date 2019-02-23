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
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func requestFoodOptions(foodId: String,
                            completionHandler: @escaping (DataResponse<FoodOptionsForView>) -> Void) {
        // 추후 url 관리 체계화 해야함
        let requestURL = URL(string: "www.uberEats.com/option")!
        network.request(with: requestURL) { [weak self] (data, response, requestError) in
            
            guard requestError == nil else {
                completionHandler(DataResponse.failed(requestError!))
                return
            }
            
            guard response?.httpStatusCode == .ok,
                let data = data,
                let _ = self else {
                    return
            }
            
            do {
                let foodOptions = try JSONDecoder().decode(FoodOptionsForNetwork.self, from: data)
                completionHandler(DataResponse.success(FoodOptionMapper.from(foodOption: foodOptions)))
            } catch let jsonDecoederError {
                completionHandler(DataResponse.failed(jsonDecoederError))
            }
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
