//
//  OrderedMenuCollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderedMenuCollectionViewCell: UICollectionViewCell {

    let numberOfFoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.text = "1"
        return label
    }()

    let orderMenuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupLayout() {
        backgroundColor = .white
        addSubview(numberOfFoodLabel)
        addSubview(orderMenuLabel)

        NSLayoutConstraint.activate([
            numberOfFoodLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberOfFoodLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberOfFoodLabel.widthAnchor.constraint(equalToConstant: 15),
            numberOfFoodLabel.heightAnchor.constraint(equalToConstant: 15),

            orderMenuLabel.leadingAnchor.constraint(equalTo: numberOfFoodLabel.trailingAnchor, constant: 20),
            orderMenuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderMenuLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
    }
}
