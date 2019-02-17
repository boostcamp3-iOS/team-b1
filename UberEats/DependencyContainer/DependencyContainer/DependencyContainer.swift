//
//  DependencyContainler.swift
//  DependencyContainer
//
//  Created by 장공의 on 06/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Waltz
import MockServer
import ServiceInterface
import Service

public class DependencyContainer {
    
    private let dependencyPool = DependencyPool()
    
    public static let share: DependencyContainer = DependencyContainer()
    
    private init() {
    
        let app = createUberEatsApplication()
        
        let mockServer = createMockServer(app: app)
   
        let foodMarketService = ServiceFactory.createFoodMarketService(network: mockServer)
        
        register(key: .foodMarketService, value: foodMarketService)
        
    }
    
    private func createUberEatsApplication() -> Application {
        do {
            return try Application("www.uberEats.com")
        } catch let error {
            fatalError("failed createUberEatsApplication \(error.localizedDescription)")
        }
    }
    
    private func createMockServer(app: Application) -> Network {
        do {
            return try MockServer(app: app)
        } catch let error {
            fatalError("failed createMockServer \(error.localizedDescription)")
        }
    }
    
    private func register<T>(key: DependencyKey, value: T) {
        do {
            try dependencyPool.register(key: .foodMarketService, value: value)
        } catch DependencyPoolError.keyAlreadyExistsError {
            fatalError("keyAlreadyExistsError \(key)")
        } catch DependencyPoolError.downcastingFailureError {
            fatalError("downcastingFailureError \(value)")
        } catch {
            fatalError("failed dependencyPool.register\(value)")
        }
    }
    
    public func getDependency<T>(key: DependencyKey) -> T {
        do {
            return try dependencyPool.getDependency(key: key)
        } catch DependencyPoolError.unregisteredKeyError {
            fatalError("unregisteredKeyError \(key)")
        } catch DependencyPoolError.downcastingFailureError {
            fatalError("downcastingFailureError \(key)")
        } catch {
            fatalError("failed getDependencyr \(key)")
        }
    }

}

public enum DependencyKey {
    case foodMarketService
    case storeService
}
