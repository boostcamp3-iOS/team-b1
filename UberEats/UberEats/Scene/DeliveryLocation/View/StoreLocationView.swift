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
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "공차"
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "#123973 주문"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .lightGray
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
        addSubview(orderNumberLabel)

        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),

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
