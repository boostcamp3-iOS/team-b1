//
//  BinaryInteger+formattedWithSeparator.swift
//  UberEats
//
//  Created by 이혜주 on 19/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
