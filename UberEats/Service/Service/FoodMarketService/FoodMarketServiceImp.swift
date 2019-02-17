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
    
    func requestFoodMarket(completionHandler: @escaping (DataResponse<BusinessFoodMarket>) -> Void) {
        let requestURL = URL(string: "www.uberEats.com/foodMarket")!
        
        network.request(with: requestURL) { ( data, response, _) in
            
            if response?.httpStatusCode == .ok {
                
                guard let data = data else {
                    return
                }
                
                do {
                    //completionHandler(DataResponse.success(foodMarket))
                    let foodMarket: FoodMarket = try JSONDecoder().decode(FoodMarket.self, from: data)
                    
                    let stores = foodMarket.stores
                    let banners: [AdvertisingBoard] = foodMarket.advertisingBoard
                    
                    let nearestRest = caculateDistance(stores: stores)
                    let recommendFood: [Food] = foodMarket.recommandFoods
                    let bannerImageURL = getBannerImageURL(banners: banners)
                    
                    let caculatedFoodMarket = BusinessFoodMarket(neareRest: nearestRest,
                                                                                     recommendFood: recommendFood,
                                                                                     bannerImages: bannerImageURL)
                    
                    DispatchQueue.main.async {
                        completionHandler(DataResponse.success(caculatedFoodMarket))
                    }
                    
                    //FIXME: - Service에서 비즈니스 로직 담당 -> nearestRest 반환하는 로직을 여기서 짜자.
                } catch {
                    fatalError()
                }
        
            } else {
                fatalError()
            }
        }
    }
    
    func requestFoodMarket(dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<BusinessFoodMarket>) -> Void) {
        dispatchQueue?.async {
            self.requestFoodMarket(completionHandler: completionHandler)
        }
    }
    
    private func caculateDistance(stores: [Store]) -> [Store] {
        var nearestRest: [Store] = []
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
        
        return nearestRest
    }
    
    private func getBannerImageURL(banners: [AdvertisingBoard]) -> [String] {
        var bannerImagesURL: [String] = []
        for banner in banners {
            bannerImagesURL.append(banner.bannerImage)
        }
        return bannerImagesURL
    }
    
}
