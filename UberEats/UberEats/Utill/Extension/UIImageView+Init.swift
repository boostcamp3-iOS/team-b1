//
//  UIImageView+Init.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension UIImageView {
    func initImageView(_ imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        return imageView
    }
}
