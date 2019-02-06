//
//  StatusCode.swift
//  Common
//
//  Created by 장공의 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public enum HTTPStatusCode: Int {

    // 100
    case `continue` = 100

    // 200
    case ok = 200

    // 400
    case badRequest = 400
    case unauthorized
    case forbidden = 403
    case notFound

    // 500
    case internalServerError = 500
    case notImplemented
    case badGateway

    case `nil` = 9999
}
