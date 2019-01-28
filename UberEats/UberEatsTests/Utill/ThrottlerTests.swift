//
//  ThrottlerTests.swift
//  UberEatsTests
//
//  Created by 장공의 on 25/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import XCTest
import UIKit
@testable import UberEats

class ThrottlerTests: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testSingleJob() {
        
        let throttler = Throttler(DispatchTimeInterval.milliseconds(500))
        let expectation = self.expectation(description: "testSingleJob")
        
        throttler.run() {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSingleJobAutherThread() {
        
        let throttler = Throttler(DispatchTimeInterval.milliseconds(500))
        let expectation = self.expectation(description: "testSingleJobAutherThread")

        throttler.run {
            DispatchQueue.global(qos: .default).async {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testMultipleJobs() {
        
        let throttler = Throttler(DispatchTimeInterval.milliseconds(500))
        let expectation = self.expectation(description: "testMultipleJobs")

        // workBeCancelled
        throttler.run {
            XCTFail()
        }
        
        throttler.run {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testJobRangeSuccess() {
        
        let throttler = Throttler(DispatchTimeInterval.milliseconds(200))
        let firstExpectation = self.expectation(description: "testJobRangeSuccess_first")
        let secondExpectation = self.expectation(description: "testJobRangeSuccess_second")

        var numberForFirst = 0
        var numberForSecond = 0
        let expectationNumberForFirst = 1
        let expectationNumberForSecond = 2
        
        throttler.run {
            numberForFirst = expectationNumberForFirst
            firstExpectation.fulfill()
        }
        
        Thread.sleep(forTimeInterval: 0.3)
        
        throttler.run {
            numberForSecond = expectationNumberForSecond
            secondExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(expectationNumberForFirst, numberForFirst)
        XCTAssertEqual(expectationNumberForSecond, numberForSecond)
    }

    func testBulkJob() {
        
        let throttler = Throttler(DispatchTimeInterval.milliseconds(500))
        let expectation = self.expectation(description: "testBulkJob")
        
        
        // 10ms * 100 == 1s
        for _ in 1..<100 {
            Thread.sleep(forTimeInterval: 0.01)
            throttler.run {
                XCTFail()
            }
        }
        
        throttler.run {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}
