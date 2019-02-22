import Foundation

public struct FoodMarketForView: Codable {
    public let advertisingBoard: [AdvertisingBoard]
    public var recommandFoods: [FoodForView]
    public var newStores, stores: [StoreForView]
}

public struct AdvertisingBoard: Codable {
    public let bannerImage: String
}
