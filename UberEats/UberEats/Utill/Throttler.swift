//
//  Throttler.swift
//  UberEats
//
//  Created by 장공의 on 25/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation
import UIKit

class Throttler {
    
    private let queue: DispatchQueue = DispatchQueue.global(qos: .background)
    private let interval: DispatchTimeInterval
    
    private var scheduledTask: DispatchWorkItem = DispatchWorkItem(block: {})
    
    init(_ interval: DispatchTimeInterval) {
        self.interval = interval
    }
    
    public func run(executionTask task: @escaping () -> ()) {
        scheduledTask.cancel()
        scheduledTask = DispatchWorkItem() { task() }
        queue.asyncAfter(deadline: .now() + interval, execute: scheduledTask)
    }
    
}


