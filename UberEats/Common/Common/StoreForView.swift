//
//  Store.swift
//  Common
//
//  Created by 이혜주 on 15/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct StoreForView: Codable {
    public let id: String
    public let mainImage: String
    public let lowImageURL: String
    public let name: String
    public let category: String
    public let deliveryTime: String
    public let openTime: OpenTime
    public let favorites: Bool
    public let location: Location
    public let rate: Rate
    public let isNewStore: Bool
    public let promotion: String
    public let numberOfCategory: Int
}

public struct Location: Codable {
    public let latitude, longtitude: Double

    public init(latitude: Double, longtitude: Double) {
        self.latitude = latitude
        self.longtitude = longtitude
    }
}

public struct OpenTime: Codable {
    public let startTime, endTime: String
}

public struct Rate: Codable {
    public let score: Double
    public let numberOfRater: Int
}
