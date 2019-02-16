//
//  MockServer.swift
//  MockServer
//
//  Created by 장공의 on 03/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import Service
import Waltz
import Common

public class MockServer {

    private let app: Application
    private let router: Router

    public init(app: Application) throws {
        self.app = app
        router = app.router
        try setUp()
    }

    private func setUp() throws {
        //"www.uberEats.com/foodMerket/food?id=12"
        try router.get("foodMarket", writtenResponse: { (request) -> Response in
            let data = try ResourceController.resourceWithData(path: request.path, root: type(of: self))

//            request.component.query
            let storesData = try ResourceController.resourceWithData(path: "www.uberEats.com/stores", root: type(of: self))

            let foodsData = try ResourceController.resourceWithData(path: "www.uberEats.com/foods", root: type(of: self))

            var foodMarket: FoodMarket = try JSONDecoder().decode(FoodMarket.self, from: data)

            do {
                let stores: [Store] = try JSONDecoder().decode([Store].self, from: storesData)
                let foods: [Food] = try JSONDecoder().decode([Food].self, from: foodsData)

                stores.forEach {
                    $0.isNewStore ? foodMarket.newStores.append($0) : foodMarket.stores.append($0)
                }

                for index in 1..<6 {
                    let storeId = "store" + String(index)
                    let foodsOfStore = foods.filter {
                        return $0.storeId == storeId
                    }

                    guard let randomFood = foodsOfStore.randomElement() else {
                        return ""
                    }

                    foodMarket.recommandFoods.append(randomFood)
                }
            } catch {
                fatalError()
            }

            guard let result = try? JSONEncoder().encode(foodMarket) else {
                return ""
            }

            return String(decoding: result, as: UTF8.self)
        })

        try router.get("menu", writtenResponse: { (request) -> Response in
            let result = try ResourceController.resourceWithString(path: request.path, root: type(of: self))

            return result
        })
    }

}

extension MockServer: Network {

    public func request(with: URL, completionHandler: (Data?, HTTPURLResponse?, Error?) -> Void) {

        do {
            let responseStrig = try router.routing(with: with)

            completionHandler(responseStrig.data(using: .utf8),
                              HTTPURLResponse.okResponse(url: with),
                              nil)

        } catch RouterError.unRegisted() {
            completionHandler(nil, HTTPURLResponse.notFoundResponse(url: with), nil)
        } catch ResourceControlError.resourceNotFoundError {
            completionHandler(nil, HTTPURLResponse.notFoundResponse(url: with), nil)
        } catch let error {
            completionHandler(nil, nil, error)
        }
    }

}
