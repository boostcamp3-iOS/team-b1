//
//  FoodMarketViewService.swift
//  Service
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import UIKit

public protocol FoodMarketService: class {
    func requestFoodMarket(completionHandler: @escaping (DataResponse<FoodMarket>) -> Void)
    func requestFoodMarket(queue: DispatchQueue?, completionHandler: @escaping (DataResponse<FoodMarket>) -> Void)
}

public struct Advertisement {
    let adTitle: String
    let adImage: UIImage
    
    init(_ adTitle: String, _ adImage: UIImage) {
        self.adTitle = adTitle
        self.adImage = adImage    
    }
}

public struct Food {
    let foodName: String
    let deliveryRequirementTime: String
    let basePrice: Int
    let foodDescription: String
    let store: Store
    var storeName: String {
        return store.name
    }
}

public struct Store {
    let name: String
}

public struct FoodMarket {
    let advertisingBoard: [Advertisement]
    let recommandFoods: [Food]
    let favoriteStores: [Store]
    let nearbyStores: [Store]
}
