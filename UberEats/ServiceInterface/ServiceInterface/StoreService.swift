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
    func requestStore(completionHandler: @escaping (DataResponse<BusinessStore>) -> Void)

    func requestStore(dispatchQueue: DispatchQueue?, completionHandler: @escaping (DataResponse<BusinessStore>) -> Void)
}
