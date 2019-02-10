//
//  FloatingView.swift
//  UberEats
//
//  Created by 이혜주 on 01/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class FloatingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        layer.cornerRadius = 18
    }

}
