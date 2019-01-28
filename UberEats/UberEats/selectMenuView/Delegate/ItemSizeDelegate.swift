//
//  HeaderItemSizeDelegate.swift
//  UberEats
//
//  Created by 이혜주 on 28/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

protocol ItemSizeDelegate {
    func changedContentOffset(curOffsetY: CGFloat, lastOffsetY: CGFloat)
}
