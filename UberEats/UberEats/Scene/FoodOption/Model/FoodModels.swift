//
//  FoodModels.swift
//  UberEats
//
//  Created by 장공의 on 18/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

enum FoodOptionItemModelType {
    case foodInfo(FoodInfoModel)
    case requiredOptions(RequiredOptionsModel)
    case additionalOptions(AdditionalOptionModel)
    case specialRequests()
    case optionItem(FoodOptionItem)
    case memo()
    case quantityControl()
    case empty()

    var identifier: String {
        switch self {
        case .foodInfo:
            return "foodInfoCell"
        case .requiredOptions:
            return "requiredOptionsCell"
        case .additionalOptions:
            return "additionalOptionsCell"
        case .specialRequests:
            return "specialRequestsCell"
        case .optionItem:
            return "checkBoxCell"
        case .memo:
            return "memoCell"
        case .quantityControl:
            return "quantityControlCell"
        case .empty:
            return "emptyCell"
        }
    }
}

struct FoodDetailDimensions {
    static let stretchableHeaderImageHeight: CGFloat = 170
    static let orderButtonCornerRadius: CGFloat = 4
}

enum CoveredToolBarStatus {
    case covered
    case uncovered
}
