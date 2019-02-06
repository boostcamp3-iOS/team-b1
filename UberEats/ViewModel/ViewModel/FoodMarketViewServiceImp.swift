//
//  FoodMarketViewModel.swift
//  ViewModel
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import UIKit

class FoodMarketViewServiceImp: FoodMarketService {
    
    func requestAdvertisingBoard(result: ([Advertisement]) -> Void) {
        
    }
}

public protocol FoodMarketService: AdvertisingBoardService {
    
}

public protocol AdvertisingBoardService {
    func requestAdvertisingBoard(result: (_ advertisingBoard: [Advertisement]) -> Void)
}

public struct Food {
    let foodName: String
    let deliveryRequirementTime: String
    let basePrice: Int
    let foodDescription: String
}

public struct Advertisement {
    let adTitle: String
    let adImage: UIImage
    
    init(_ adTitle: String, _ adImage: UIImage) {
        self.adTitle = adTitle
        self.adImage = adImage
    }
}
