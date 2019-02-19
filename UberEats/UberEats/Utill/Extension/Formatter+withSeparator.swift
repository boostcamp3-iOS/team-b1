//
//  Formatter.swift
//  UberEats
//
//  Created by 이혜주 on 19/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
