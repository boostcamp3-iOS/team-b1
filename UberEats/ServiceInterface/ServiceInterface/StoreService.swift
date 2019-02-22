//
//  StoreService.swift
//  ServiceInterface
//
//  Created by 이혜주 on 15/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Common

public protocol StoreService: class {
    func requestStore(storeId: String,
                      completionHandler: @escaping (DataResponse<StoreForNetwork>) -> Void)

    func requestStore(storeId: String,
                      dispatchQueue: DispatchQueue?,
                      completionHandler: @escaping (DataResponse<StoreForNetwork>) -> Void)
}
