//
//  DependencyPool.swift
//  DependencyContainer
//
//  Created by 장공의 on 07/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

class DependencyPool {
    
    private var dependencyPool = [DependencyKey: Any]()
    
    func register<T>(key: DependencyKey, value: T) throws {
        
        guard dependencyPool[key] == nil else {
            throw DependencyPoolError.keyAlreadyExistsError(key: key)
        }
        
        dependencyPool[key] = value
    }
    
    func getDependency<T>(key: DependencyKey) throws -> T {
        
        guard let dependency = dependencyPool[key] else {
            throw DependencyPoolError.unregisteredKeyError(key: key)
        }
        
        guard dependency is T else {
            
            throw DependencyPoolError.downcastingFailureError(key: key)
        }
        
        return dependency as! T
    }
    
}

enum DependencyPoolError: Error {
    case keyAlreadyExistsError(key: DependencyKey)
    case unregisteredKeyError(key: DependencyKey)
    case downcastingFailureError(key: DependencyKey)
}
