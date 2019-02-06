//
//  Router.swift
//  Waltz
//
//  Created by 장공의 on 02/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public class Router {
    
    let baseUrl: URL
    
    // 메모리 누수 처리
    private(set) var table: RoutingTable
    
    init(_ base: String) throws {
        guard let baseUrl = URL(string: base) else {
            throw RouterError.invailedArgument()
        }
        
        table = RoutingTable()
        self.baseUrl = baseUrl
    }
    
    public func routing(with: URL) throws -> Response {
        guard let components = URLComponents(url: with, resolvingAgainstBaseURL: true) else {
            // http://bitly.kr/hlmeD
            throw RouterError.invailedArgument()
        }
        
        let handler = try table.getHandler(routedPath: with.path)
        return try handler(DataRequest(components))
    }
    
}

public enum RouterError: Error {
    case aleadyRegisted()
    case unRegisted()
    case invailedArgument()
}
