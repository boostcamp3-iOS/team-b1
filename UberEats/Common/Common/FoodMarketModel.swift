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
    public let mainImage, name, category, deliveryTime: String
    public let openTime: OpenTime
    public let favorites: Bool
    public let location: Location
    public let rate: Rate
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

public struct RecommandFood: Codable {
    public let foodName: String
    public let basePrice: Int
    public let foodDescription: String
    public let foodImageURL: String
    public let store: Store

}
