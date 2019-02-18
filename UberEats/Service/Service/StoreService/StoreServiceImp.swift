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
    
    func requestStore(query: String, completionHandler: @escaping (DataResponse<BusinessStore>) -> Void) {
        guard let requestURL = URL(string: "www.uberEats.com/stores?" + query) else {
            fatalError("URL conversion error")
        }
        
        network.request(with: requestURL) { ( data, response, _) in
            if response?.httpStatusCode == .ok {
                
                guard let data = data else {
                    return
                }
                
                do {
                    let store: Store = try JSONDecoder().decode(Store.self, from: data)
                    
                    let caculatedStore = BusinessStore(store)
                    
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
    
    func requestStore(query: String, dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<BusinessStore>) -> Void) {
        dispatchQueue?.async {
            self.requestStore(query: query, completionHandler: completionHandler)
        }
    }
    
}
