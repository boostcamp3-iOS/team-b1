//
//  DeliveryManLocationView.swift
//  UberEats
//
//  Created by 이혜주 on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class StoreLocationView: UIView {

    let locationLabel: UILabel = {
        let label = UILabel().setupWithFontSize(15)
        label.textAlignment = .center
        return label
    }()

    let orderNumberLabel: UILabel = {
        let label = UILabel().setupWithFontSize(10)
        label.text = "#123973 주문"
        label.textColor = .lightGray
        return label
    }()

    var storeName: String? {
        didSet {
            guard let storeName = storeName else {
                return
            }

            locationLabel.text = storeName
        }
    }

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
        addSubview(orderNumberLabel)

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            orderNumberLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            orderNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
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
