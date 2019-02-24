//
//  BusinessFoodMarket.swift
//  Common
//
//  Created by 이혜주 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct FoodMarketForNetwork {
    public let nearestRest: [StoreForView]
    public let recommendFood: [FoodForView]
    public let bannerImages: [String]
    public let expectTimeRest: [StoreForView]
    public let newRests: [StoreForView]
    public let moreRests: [StoreForView]

    public init(neareRest: [StoreForView],
                recommendFood: [FoodForView],
                bannerImages: [String],
                expectTimeRest: [StoreForView],
                newRests: [StoreForView],
                moreRests: [StoreForView]) {
        self.nearestRest = neareRest
        self.recommendFood = recommendFood
        self.bannerImages = bannerImages
        self.expectTimeRest = expectTimeRest
        self.newRests = newRests
        self.moreRests = moreRests
    }
}

public struct moreRestForNetwork {
    public let resultRest: [StoreForView]

    public init(resultRest: [StoreForView]) {
        self.resultRest = resultRest
    }
}
