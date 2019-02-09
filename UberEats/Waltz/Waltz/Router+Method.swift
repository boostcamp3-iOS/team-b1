//
//  Router+Method.swift
//  Waltz
//
//  Created by 장공의 on 02/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public typealias Response = String
public typealias RespnseHandler = (_ request: DataRequest) throws -> Response

extension Router {
    
    public func get(_ requestPath: String, writtenResponse: @escaping RespnseHandler) throws {
        try table.regist(routingPath: baseUrl.appendingPathComponent(requestPath),
                         routedHandler: writtenResponse)
    }
}
