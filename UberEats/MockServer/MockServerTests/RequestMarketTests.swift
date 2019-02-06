//
//  requestMarketTest.swift
//  MockServerTests
//
//  Created by 장공의 on 06/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import XCTest
@testable import MockServer
@testable import Waltz
@testable import Common

class RequestMarketTests: XCTestCase {

    private let resourcesURL = "www.uberEats.com"

    func testRequestMarket() {

        do {

            let mockingApp = try Application(resourcesURL)

            let expectedResponseData = "{\n    \"test\": \"ok\"\n}"

            let server = try MockServer(app: mockingApp)

            let request = mockingApp.baseUrl.appendingPathComponent("market")

            server.request(with: request) { (data, response, error) in
                guard data != nil, response != nil, error == nil else {
                    return XCTFail()
                }

                guard let responseData = String(data: data!, encoding: .utf8) else {
                    return XCTFail("failed data encoding")
                }

                guard response!.httpStatusCode == HTTPStatusCode.ok else {
                    return XCTFail("Status code is not 200... code = \(response!.httpStatusCode)")
                }

                XCTAssertEqual(expectedResponseData, responseData)

            }
        } catch let error {
            XCTFail(error.localizedDescription)
        }

    }

}
