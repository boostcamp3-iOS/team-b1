//
//  FoodMarketServiceImp.swift
//  Service
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common
import CoreLocation
import ServiceInterface

internal class FoodMarketServiceImp: FoodMarketService {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func requestFoodMarket(completionHandler: @escaping (DataResponse<CaculatedFoodMarket>) -> Void) {
        let requestURL = URL(string: "www.uberEats.com/foodMarket")!
        network.request(with: requestURL) { ( data, response, _) in
            if response?.httpStatusCode == .ok {
                guard let data = data else {
                    return
                }
                do {
                    let foodMarket: FoodMarket = try JSONDecoder().decode(FoodMarket.self, from: data)
                    //completionHandler(DataResponse.success(foodMarket))
                    let stores = foodMarket.stores
                    
                    var nearestRest: [Store] = []
                    let recommendFood: [RecommandFood] = foodMarket.recommandFoods
                    let banners: [AdvertisingBoard] = foodMarket.advertisingBoard
                    
                    var bannerImagesURL: [String] = []
                    
                    for banner in banners {
                        bannerImagesURL.append(banner.bannerImage)
                    }
                    
                    for store in stores {
                        let currentLatitude: Double = 37.498146
                        let currentLongtitude: Double = 127.027642
                        
                        let storeCoordinate = CLLocation(latitude: store.location.latitude, longitude: store.location.longtitude)
                        let currentCoordinate = CLLocation(latitude: currentLatitude, longitude: currentLongtitude)
                        
                        let distance = storeCoordinate.distance(from: currentCoordinate) / 1000
                        
                        if distance < 2.0 {
                            nearestRest.append(store)
                        }
                    }
                    
                    let caculatedFoodMarket: CaculatedFoodMarket = CaculatedFoodMarket(neareRest: nearestRest,
                                                                                       recommendFood: recommendFood, bannerImages: bannerImagesURL)
                    
                    completionHandler(DataResponse.success(caculatedFoodMarket))
                    
                    //FIXME: - Service에서 비즈니스 로직 담당 -> nearestRest 반환하는 로직을 여기서 짜자.
                } catch {
                    fatalError()
                }
        
            } else {
                fatalError()
            }
            
        }
    }
    
    func requestFoodMarket(dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<CaculatedFoodMarket>) -> Void) {
        dispatchQueue?.async {
            self.requestFoodMarket(completionHandler: completionHandler)
        }
    }
    
}
