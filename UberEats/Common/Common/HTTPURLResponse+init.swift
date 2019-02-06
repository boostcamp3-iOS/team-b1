//
//  HTTPURLResponse+init.swift
//  Common
//
//  Created by 장공의 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public extension HTTPURLResponse {

    public convenience init(url: URL, statusCode: HTTPStatusCode, headerFields: [String: String]?) {
        self.init(url: url, statusCode: statusCode.rawValue, httpVersion: nil, headerFields: nil)!
    }

    public static func notFoundResponse(url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: .notFound, headerFields: nil)
    }

    public static func okResponse(url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: .ok, headerFields: nil)
    }
}
