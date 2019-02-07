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
import Service

public class DependencyContainer {
    
    private var dependencyPool = [DependencyKey: AnyObject]()
    
    public static let share: DependencyContainer = DependencyContainer()
    
    private init() {
    
        let app = createUberEatsApplication()
        
        let mockServer = createMockServer(app: app)
   
        let foodMarketService = ServiceFactory.createFoodMarketService(network: mockServer)
        
        dependencyPool[DependencyKey.foodMarketService] = foodMarketService
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
    
    public func getDependency(key: DependencyKey) -> AnyObject {
        return dependencyPool[key]!
    }

}

public enum DependencyKey {
    case foodMarketService
}
