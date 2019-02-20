//
//  UILabel+.swift
//  UberEats
//
//  Created by 이혜주 on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension UILabel {
    func setupWithFontSize(_ size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: size)
        return label
    }
}
