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
    public let store: Store

    public init(_ store: Store) {
        self.store = store
    }
}
