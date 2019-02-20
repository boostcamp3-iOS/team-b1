//
//  FoodModels.swift
//  UberEats
//
//  Created by 장공의 on 18/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

enum FoodOptionItemModelType {
    case requiredOptions(RequiredOptionsModel)
    case additionalOptions(AdditionalOptionModel)
    case specialRequests(SpecialRequestsModel)
    case checkBox(CheckBoxModel)
    case radioButton(RadioButtonModel)
}

enum FoodOptionSection: Int, CaseIterable {
    case requiredOptions = 0
    case additionalOptions
    case specialRequests
    case checkBox
    case radioButton
    case empty

    var identifier: String {
        switch self {
        case .requiredOptions:
            return "requiredOptionsCell"
        case .additionalOptions:
            return "additionalOptionsCell"
        case .specialRequests:
            return "specialRequestsCell"
        case .checkBox:
            return "checkBoxCell"
        case .radioButton:
            return "radioButtonCell"
        case .empty:
            return "emptyCell"
        }
    }
}

protocol FoodOptionsType {
    var name: String { get set }
    var selectionCondition: String { get set}
}

protocol FoodOptions {
    var name: String { get set }
    var price: Int { get set }
}

struct RequiredOptionsModel: FoodOptionsType {
    var name: String
    var selectionCondition: String
}

struct AdditionalOptionModel: FoodOptionsType {
    var name: String
    var selectionCondition: String
}

struct SpecialRequestsModel: FoodOptionsType {
    var name: String
    var selectionCondition: String
}

struct CheckBoxModel: FoodOptions {
    var name: String
    var price: Int
}

struct RadioButtonModel: FoodOptions {
    var name: String
    var price: Int
}

struct FoodDetailDimensions {
    static let stretchableHeaderImageHeight: CGFloat = 170
    static let orderButtonCornerRadius: CGFloat = 4
}

enum CoveredToolBarStatus {
    case covered
    case uncovered
}
