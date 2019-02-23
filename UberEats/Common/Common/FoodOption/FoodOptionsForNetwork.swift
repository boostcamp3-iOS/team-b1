//
//  FoodOptionsForNetwork.swift
//  Common
//
//  Created by 장공의 on 23/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct FoodOptionsForNetwork: Codable {
    public let id: String
    public let requiredOptions: [Option]

}

public struct Option: Codable {
    public let name: String
    public let supportingExplanation: String
    public let optionItems: [OptionItem]
}

public struct OptionItem: Codable {
    public let name: String
    public let price: Int
}
