//
//  UITableViewCell+ViewOption.swift
//  UberEats
//
//  Created by 장공의 on 12/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/8561774/hide-separator-line-on-one-uitableviewcell
extension UITableViewCell {

    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0,
                                           left: self.bounds.size.width,
                                           bottom: 0,
                                           right: 0)
    }

    func showSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
    }
}
