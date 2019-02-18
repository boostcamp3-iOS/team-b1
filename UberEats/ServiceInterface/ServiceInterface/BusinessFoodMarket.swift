//
//  CaculatedFoodMarket.swift
//  Common
//
//  Created by admin on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

public struct BusinessFoodMarket {
    public let nearestRest: [Store]
    public let recommendFood: [Food]
    public let bannerImages: [String]
    public let expectTimeRest: [Store]
    public let newRests: [Store]

    public init(neareRest: [Store], recommendFood: [Food], bannerImages: [String], expectTimeRest: [Store], newRests: [Store]) {
        self.nearestRest = neareRest
        self.recommendFood = recommendFood
        self.bannerImages = bannerImages
        self.expectTimeRest = expectTimeRest
        self.newRests = newRests
    }
}
