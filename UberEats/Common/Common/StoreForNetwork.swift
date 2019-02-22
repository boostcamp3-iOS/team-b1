//
//  BusinessStore.swift
//  Common
//
//  Created by 이혜주 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct StoreForNetwork {
    public let store: StoreForView

    public init(_ store: StoreForView) {
        self.store = store
    }
}
