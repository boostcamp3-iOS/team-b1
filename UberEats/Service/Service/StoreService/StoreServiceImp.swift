//
//  StoreServiceImp.swift
//  Service
//
//  Created by 이혜주 on 15/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common
import ServiceInterface

class StoreServiceImp: StoreService {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func requestStore(storeId: String, completionHandler: @escaping (DataResponse<StoreForNetwork>) -> Void) {
        guard let requestURL = URL(string: "www.uberEats.com/stores?" + storeId) else {
            fatalError("URL conversion error")
        }
        
        network.request(with: requestURL) { ( data, response, _) in
            if response?.httpStatusCode == .ok {
                
                guard let data = data else {
                    return
                }
                
                do {
                    let store: StoreForView = try JSONDecoder().decode(StoreForView.self, from: data)
                    
                    let caculatedStore = StoreForNetwork(store)
                    
                    DispatchQueue.main.async {
                        completionHandler(DataResponse.success(caculatedStore))
                    }
                } catch {
                    fatalError()
                }
                
            } else {
                fatalError()
            }
        }
    }
    
    func requestStore(storeId: String, dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<StoreForNetwork>) -> Void) {
        dispatchQueue?.async {
            self.requestStore(storeId: storeId, completionHandler: completionHandler)
        }
    }
    
}
