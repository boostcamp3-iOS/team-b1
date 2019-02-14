//
//  CaculatedFoodMarket.swift
//  Common
//
//  Created by admin on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

public struct CaculatedFoodMarket {
    public let nearestRest: [Store]
    public let recommendFood: [RecommandFood]
    public let bannerImages: [String]

    public init(neareRest: [Store], recommendFood: [RecommandFood], bannerImages: [String]) {
        self.nearestRest = neareRest
        self.recommendFood = recommendFood
        self.bannerImages = bannerImages
    }
}
