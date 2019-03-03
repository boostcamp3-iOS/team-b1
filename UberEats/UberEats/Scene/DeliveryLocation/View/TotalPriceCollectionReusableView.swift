//
//  TotalPriceCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class TotalPriceCollectionReusableView: UICollectionReusableView {

    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let billButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("영수증 보기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .white

        addSubview(totalPriceLabel)
        addSubview(billButton)

        NSLayoutConstraint.activate([
            totalPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            totalPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),

            billButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            billButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)

            ])
    }

    func configure(totalPrice: String) {
        totalPriceLabel.text = "￦" + totalPrice
    }
}
