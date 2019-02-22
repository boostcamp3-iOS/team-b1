//
//  Store.swift
//  Common
//
//  Created by 이혜주 on 15/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct FoodForView: Codable {
    public let id: String
    public let foodName: String
    public let foodDescription: String
    public let foodImageURL: String
    public let lowImageURL: String
    public let basePrice: Int
    public let storeId: String
    public let categoryId: String
    public let categoryName: String
}
