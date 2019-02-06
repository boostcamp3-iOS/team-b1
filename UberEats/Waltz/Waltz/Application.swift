//
//  Waltz.swift
//  Waltz
//
//  Created by 장공의 on 01/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public class Application {
    
    public let router: Router
    
    public var baseUrl: URL {
        get {
            return router.baseUrl
        }
    }
    
    public init(_ base: String) throws {
        router = try Router(base)
    }
    
}
