//
//  FoodMarketService.swift
//  ServiceInterface
//
//  Created by 장공의 on 07/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public protocol FoodMarketService: class {

    func requestFoodMarket(completionHandler: @escaping (DataResponse<FoodMarketForNetwork>) -> Void)

    func requestFoodMarket(dispatchQueue: DispatchQueue?,
                           completionHandler: @escaping (DataResponse<FoodMarketForNetwork>) -> Void)

    func requestFoodMarketMore(section: TableViewSection, completionHandler: @escaping (DataResponse<[StoreForView]>) -> Void)

    func requestFoodMarketMore(dispatchQueue: DispatchQueue?, section: TableViewSection,
                               completionHandler: @escaping (DataResponse<[StoreForView]>) -> Void)

}
