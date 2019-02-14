import Foundation

public struct FoodMarket: Codable {
    public let advertisingBoard: [AdvertisingBoard]
    public let recommandFoods: [RecommandFood]
    public let newStores, stores: [Store]
}

public struct AdvertisingBoard: Codable {
    public let bannerImage: String
}

public struct Store: Codable {
    public let mainImage, name, category, deliveryTime, id: String
    public let openTime: OpenTime
    public let favorites: Bool
    public let location: Location
    public let rate: Rate
    public let foodsId: [String]
}

public struct RecommandFood: Codable {
    public let id, foodName, foodDescription, foodImageURL: String
    public let basePrice: Int
    public let storeId: String
}

public struct Location: Codable {
    public let latitude, longtitude: Double
}

public struct OpenTime: Codable {
    public let startTime, endTime: String
}

public struct Rate: Codable {
    public let score: Double
    public let numberOfRater: Int
}
