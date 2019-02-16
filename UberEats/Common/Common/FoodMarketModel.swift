import Foundation

public struct FoodMarket: Codable {
    public let advertisingBoard: [AdvertisingBoard]
    public var recommandFoods: [Food]
    public var newStores, stores: [Store]
}

public struct AdvertisingBoard: Codable {
    public let bannerImage: String
}
