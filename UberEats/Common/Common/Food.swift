//
//  Store.swift
//  Common
//
//  Created by 이혜주 on 15/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct Food: Codable {
    public let id, foodName, foodDescription, foodImageURL, lowImageURL: String
    public let basePrice: Int
    public let storeId: String
    public let categoryId: String
    public let categoryName: String
}
