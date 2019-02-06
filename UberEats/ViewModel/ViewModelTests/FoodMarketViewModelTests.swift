//
//  ViewModelTests.swift
//  ViewModelTests
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import XCTest
@testable import ViewModel

class FoodMarketServiceTests: XCTestCase {
    typealias AdvertisingBoard = (_ advertisingBoard: [Advertisement]) -> Void
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAdvertisingBoard() {
        let viewModel = FoodMarketViewModel()
        
        viewModel.requestAdvertisingBoard { _ in
            
        }
    }
}

//
//  FoodMarketViewModel.swift
//  ViewModel
//
//  Created by 장공의 on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import UIKit

class FoodMarketViewServiceImp: FoodMarketService {
    
    func requestAdvertisingBoard(result: ([Advertisement]) -> Void) {
        
    }
}
