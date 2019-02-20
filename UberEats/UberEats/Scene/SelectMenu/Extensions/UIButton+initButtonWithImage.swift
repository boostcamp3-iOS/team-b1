//
//  Extensions.swift
//  UberEats
//
//  Created by 이혜주 on 01/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension UIButton {
    func initButtonWithImage(_ imageName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
}
