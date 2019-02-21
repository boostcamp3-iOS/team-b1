//
//  OrderedMenuCollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderedMenuCollectionViewCell: UICollectionViewCell {

    private struct NumberForCell {
        static let foodLabelLeadingAndTrailingMargin: CGFloat = 20

        static let orderMenuLabelFontSize: CGFloat = 15
        static let orderMenuLabelLeadingMargin: CGFloat = 20
        static let orderMenuLabelNumberOfLines: Int = 2

        static let numberOfFoodLabelFontSize: CGFloat = 13
        static let numberOfFoodLabelSize: CGFloat = 15
        static let numberOfFoodBorderWidth: CGFloat = 1
    }

    let numberOfFoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        label.layer.borderWidth = NumberForCell.numberOfFoodBorderWidth
        label.textAlignment = .center
        label.font = .systemFont(ofSize: NumberForCell.numberOfFoodLabelFontSize)
        label.textColor = .darkGray
        label.text = "1"
        return label
    }()

    let orderMenuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = NumberForCell.orderMenuLabelNumberOfLines
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: NumberForCell.orderMenuLabelFontSize)
        return label
    }()

    var numberOfFood: Int? {
        didSet {
            guard let numberOfFood = numberOfFood else {
                return
            }

            numberOfFoodLabel.text = String(numberOfFood)
        }
    }

    var foodName: String? {
        didSet {
            guard let foodName = foodName else {
                return
            }

            orderMenuLabel.text = foodName
        }
    }

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

            numberOfFoodLabel
                .leadingAnchor.constraint(equalTo: leadingAnchor,
                                          constant: NumberForCell.foodLabelLeadingAndTrailingMargin),

            numberOfFoodLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),

            numberOfFoodLabel.widthAnchor
                .constraint(equalToConstant: NumberForCell.numberOfFoodLabelSize),

            numberOfFoodLabel.heightAnchor
                .constraint(equalToConstant: NumberForCell.numberOfFoodLabelSize),

            orderMenuLabel.leadingAnchor
                .constraint(equalTo: numberOfFoodLabel.trailingAnchor,
                            constant: NumberForCell.orderMenuLabelLeadingMargin),

            orderMenuLabel.centerYAnchor
                .constraint(equalTo: centerYAnchor),

            orderMenuLabel.trailingAnchor
                .constraint(equalTo: trailingAnchor,
                            constant: -NumberForCell.foodLabelLeadingAndTrailingMargin)
            ])
    }
}
