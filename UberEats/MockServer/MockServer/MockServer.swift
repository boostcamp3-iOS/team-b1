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
