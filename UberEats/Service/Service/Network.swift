//
//  Network.swift
//  Service
//
//  Created by 장공의 on 03/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

public protocol Network {
    
    func request(with: URL, completionHandler: (Data?, HTTPURLResponse?, Error?) -> Void)
    
}
