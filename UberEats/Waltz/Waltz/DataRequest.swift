//
//  DataRequest.swift
//  Waltz
//
//  Created by 장공의 on 02/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public struct DataRequest {
    
    public let component: URLComponents
    
    init(_ compnent: URLComponents) {
        self.component = compnent
    }
    
    public var path: String {
        get {
            return component.path
        }
    }
    
}
