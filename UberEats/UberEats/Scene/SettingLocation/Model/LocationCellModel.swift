//
//  SettingLocationModel.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

struct LocationCellModel {
    let imageName: String
    let title: String
    let address: String
    let option: String

    init(imageName: String, title: String, option: String) {
        self.init(imageName, title, "", option)
    }

    init(_ imageName: String, _ title: String, _ address: String, _ option: String) {
        self.imageName = imageName
        self.title = title
        self.address = address
        self.option = option
    }
}

struct MomentCellModel {
    let imageName: String
    let title: String
}
