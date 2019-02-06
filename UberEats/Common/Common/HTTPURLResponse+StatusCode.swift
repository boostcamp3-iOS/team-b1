//
//  HTTPURLResponse+StatusCode.swift
//  Common
//
//  Created by 장공의 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public extension HTTPURLResponse {

    var httpStatusCode: HTTPStatusCode {
        get {

            guard let code = HTTPStatusCode(rawValue: statusCode) else {
                return HTTPStatusCode.nil
            }

            return code
        }
    }

}
