//
//  RoutingTable.swift
//  Waltz
//
//  Created by 장공의 on 05/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

class RoutingTable {
    
    private var table: [String: RespnseHandler] = [:]
    
    func regist(routingPath key: URL, routedHandler handler: @escaping RespnseHandler) throws {
        try regist(routingPath: key.path, routedHandler: handler)
    }
    
    func regist(routingPath path: String, routedHandler handler: @escaping RespnseHandler) throws {
        guard !isRegistered(routingPath: path) else {
            throw RouterError.aleadyRegisted()
        }
        
        table[path] = handler
    }
    
    func getHandler(routedPath path: String) throws -> RespnseHandler {
        guard isRegistered(routingPath: path), let handler = table[path] else {
            throw RouterError.unRegisted()
        }
        
        return handler
    }
    
    func isRegistered(routingPath key: String) -> Bool {
        guard table[key] == nil else {
            return true
        }
        
        return false
    }
    
}
