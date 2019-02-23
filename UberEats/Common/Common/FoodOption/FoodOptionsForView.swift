//
//  FoodOptionsForView.swift
//  Common
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct FoodOptionsForView {
    public let foodInfoModel: FoodInfoModel
    public let requiredOptionsModel: [RequiredOptionsModel]

    public init(foodInfoModel: FoodInfoModel, requiredOptionsModel: [RequiredOptionsModel]) {
        self.foodInfoModel = foodInfoModel
        self.requiredOptionsModel = requiredOptionsModel
    }

    public init(requiredOptionsModel: [RequiredOptionsModel]) {
        self.init(foodInfoModel: FoodInfoModel(name: "", supportingExplanation: "", price: 0, imageURL: ""),
                  requiredOptionsModel: requiredOptionsModel)
    }
}

public protocol HavingFoodOptionItems {
    var foodOptionItems: [FoodOptionItem] { get set }
}

public protocol FoodOptionsCategory {
    var name: String { get set }
    var supportingExplanation: String { get set}
}

public protocol FoodOptionItem {
    var name: String { get set }
    var price: Int { get set }
}

public struct FoodInfoModel: FoodOptionsCategory {
    public var name: String
    public var supportingExplanation: String
    public let price: Int
    public let imageURL: String

    public init(name: String, supportingExplanation: String, price: Int, imageURL: String) {
        self.name = name
        self.supportingExplanation = supportingExplanation
        self.price = price
        self.imageURL = imageURL
    }
}

public struct RequiredOptionsModel: FoodOptionsCategory, HavingFoodOptionItems {
    public var foodOptionItems: [FoodOptionItem]
    public var name: String
    public var supportingExplanation: String

    public init(foodOptionItems: [FoodOptionItem],
                name: String,
                supportingExplanation: String) {
        self.foodOptionItems = foodOptionItems
        self.name = name
        self.supportingExplanation = supportingExplanation
    }
}

public struct AdditionalOptionModel: FoodOptionsCategory, HavingFoodOptionItems {
    public var foodOptionItems: [FoodOptionItem]
    public var name: String
    public var supportingExplanation: String

    public init(foodOptionItems: [FoodOptionItem],
                name: String,
                supportingExplanation: String) {
        self.foodOptionItems = foodOptionItems
        self.name = name
        self.supportingExplanation = supportingExplanation
    }
}

public struct CheckBoxModel: FoodOptionItem {
    public var name: String
    public var price: Int

    public init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}

public struct RadioButtonModel: FoodOptionItem {
    public var name: String
    public var price: Int

    public init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}
