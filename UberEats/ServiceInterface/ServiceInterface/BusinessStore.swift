//
//  BusinessStore.swift
//  ServiceInterface
//
//  Created by 이혜주 on 15/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public struct BusinessStore {
    public let stores: [Store]

    public init(_ stores: [Store]) {
        self.stores = stores
    }
}
