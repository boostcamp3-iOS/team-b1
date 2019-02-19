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
        network.request(with: requestURL) { ( data, response, requestError) in
            
            if let requestError = requestError {
                completionHandler(DataResponse.failed(requestError))
                return
            }
            
            if response?.httpStatusCode == .ok {
                guard let data = data else {
                    //completionHandler(DataResponse.failed(NetworkError.noDataReceived()))
                    return
                }
                do {
                    let foodMarket: FoodMarket = try JSONDecoder().decode(FoodMarket.self, from: data)
                    
                    let stores = foodMarket.stores
                    
                    let banners: [AdvertisingBoard] = foodMarket.advertisingBoard
                    
                    let nearestRest: [Store] = caculateDistance(stores: stores)
                    let recommendFood: [Food] = foodMarket.recommandFoods
                    let bannerImageURL: [String] = getBannerImageURL(banners: banners)
                    let expectTimeRest: [Store] = caculateExpectTime(stores: stores)
                    let newRests: [Store] = foodMarket.newStores
                    
                    let caculatedFoodMarket = BusinessFoodMarket(neareRest: nearestRest,
                                                                 recommendFood: recommendFood,
                                                                 bannerImages: bannerImageURL,
                                                                 expectTimeRest: expectTimeRest,
                                                                 newRests: newRests,
                                                                 moreRests: stores
                                                                 )
                    
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
    
    private func caculateExpectTime(stores: [Store]) -> [Store] {
        
        var expectTimeStore: [Store] = []
        var expectTimes: [String] = []
        
        for store in stores {
            expectTimes =  store.deliveryTime.components(separatedBy: "-")
            
            var expectTimeInt: [Double?] = []
            expectTimeInt.append(Double(expectTimes[0]))
            expectTimeInt.append(Double(expectTimes[1]))
            
            if let fastestTime = expectTimeInt[0], let latestTime = expectTimeInt[1] {
                if fastestTime <= 30 {
                    expectTimeStore.append(store)
                }
            }
            
        }
        
        return expectTimeStore
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
    
    /*
    private func caculateNewRest(stores: [Store]) -> [Store] {
        var newRests: [Store] = []
        for store in stores {
            if store.isNewStore {
                newRests.append(store)
            }
        }
        
        return newRests
    }
     */
}
