//
//  Message.swift
//  UberEats
//
//  Created by admin on 02/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import Foundation

class Message: NSObject {
    var text: String?
    var userEmail: String?

    override init() {
        print("init")
    }

    init(text: String, userEmail: String) {
        self.text = text
        self.userEmail = userEmail
    }
}
