//
//  BusinessFoodMarket.swift
//  Common
//
//  Created by 이혜주 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct FoodMarketForNetwork {
    public let nearestRest: [Store]
    public let recommendFood: [Food]
    public let bannerImages: [String]
    public let expectTimeRest: [Store]
    public let newRests: [Store]
    public let moreRests: [Store]

    public init(neareRest: [Store],
                recommendFood: [Food],
                bannerImages: [String],
                expectTimeRest: [Store],
                newRests: [Store],
                moreRests: [Store]) {
        self.nearestRest = neareRest
        self.recommendFood = recommendFood
        self.bannerImages = bannerImages
        self.expectTimeRest = expectTimeRest
        self.newRests = newRests
        self.moreRests = moreRests
    }
}
