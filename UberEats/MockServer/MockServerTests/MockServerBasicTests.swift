//
//  MockServerTests.swift
//  MockServerTests
//
//  Created by 장공의 on 03/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import XCTest
@testable import MockServer
@testable import Waltz
@testable import Common

class MockServerBasicTests: XCTestCase {

    private let testUrl = "www.test.com"

    func testResponseSuccess() {

        do {

            let mockingApp = try Application(testUrl)
            let path = UUID().uuidString
            let expectedResponseData = "마시쩡"

            try mockingApp.router.get(path) { _ in
                return expectedResponseData
            }

            let server = try MockServer(app: mockingApp)

            let request = mockingApp.baseUrl.appendingPathComponent(path)

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

    func testResponseFail() {

        do {
            let mockingApp = try Application(testUrl)
            let server = try MockServer(app: mockingApp)
            let wrongPath = "tost"
            let request = URL(string: wrongPath, relativeTo: mockingApp.baseUrl)!

            server.request(with: request) { (data, response, error) in
                guard data == nil, response != nil, error == nil else {
                    return XCTFail()
                }

                guard response!.httpStatusCode == HTTPStatusCode.notFound else {
                    return XCTFail("Status code is not 404... code = \(response!.httpStatusCode)")
                }

            }

        } catch {
            XCTFail()
        }

    }

    func testResponseWithQuery() {

        do {
            let mockingApp = try Application(testUrl)
            let server = try MockServer(app: mockingApp)
            let requestURL = URL(string: "www.test.com/movies?order_type=1")!

            try mockingApp.router.get("movies") { request in

                let component = request.component

                XCTAssertEqual(requestURL.path, component.path)
                XCTAssertEqual(requestURL.query, component.query)

                return ""
            }

            server.request(with: requestURL) { (data, response, error) in
                guard data != nil, response != nil, error == nil else {
                    return XCTFail()
                }

                guard response!.httpStatusCode == HTTPStatusCode.ok else {
                    return XCTFail("Status code is not 200... code = \(response!.httpStatusCode)")
                }
            }

        } catch {
            XCTFail(error.localizedDescription)
        }

    }

}
