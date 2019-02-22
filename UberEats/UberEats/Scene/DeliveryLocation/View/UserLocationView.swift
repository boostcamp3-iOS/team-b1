//
//  userLocationView.swift
//  UberEats
//
//  Created by 이혜주 on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class UserLocationView: UIView {

    let locationLabel: UILabel = {
        let label = UILabel().setupWithFontSize(15)
        label.text = "메리츠타워"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .white
        addSubview(locationLabel)

        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    private func setupContentView() {
        layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
    }
}
