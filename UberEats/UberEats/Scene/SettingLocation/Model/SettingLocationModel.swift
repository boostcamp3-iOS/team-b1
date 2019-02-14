//
//  SettingLocationModel.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

struct ConstraintOfSettingLocation {
    static let buttonSizeAtSettingLocation: CGFloat = 20
    static let paddingAtSettingLocation: CGFloat = 20

    static let trailingOfMainLabel: CGFloat = 10
    static let trailingOfselectStatus: CGFloat = 15
    static let leadingOfLabelAndTextField: CGFloat = 20
}

enum SettingLocationCellId: String {
    case newAddress = "newAddressCellId"
    case location = "locationCellId"
    case moment = "momentCellId"
}

enum SectionOfSettingLocation: Int {
    case newAddress = 0
    case location
    case moment
}
