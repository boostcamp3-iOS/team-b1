//
//  FoodCollectionViewCell.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import Common

class FoodCollectionViewCell: UICollectionViewCell {

    var priceLabelBottomConstraint = NSLayoutConstraint()
    var foodImageViewWidthConstraint = NSLayoutConstraint()

    let foodNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()

    let foodContentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var food: Food? {
        didSet {
            guard let food = food else {
                return
            }

            foodNameLabel.text = food.foodName
            foodContentsLabel.text = food.foodDescription
            priceLabel.text = "￦" + String(food.basePrice)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    func setupLayout() {
        backgroundColor = .white
        addSubview(foodNameLabel)
        addSubview(foodContentsLabel)
        addSubview(priceLabel)
        addSubview(foodImageView)

        priceLabelBottomConstraint = NSLayoutConstraint(item: priceLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        priceLabelBottomConstraint.isActive = true

        foodImageViewWidthConstraint = foodImageView.widthAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([
            foodNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            foodNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            foodNameLabel.trailingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: -10),

            foodContentsLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 10),
            foodContentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            foodContentsLabel.trailingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: -10),

            priceLabel.topAnchor.constraint(equalTo: foodContentsLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            priceLabel.trailingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: -10),

            foodImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            foodImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        foodNameLabel.text = ""
        foodContentsLabel.text = ""
        priceLabel.text = ""
        foodImageView.image = nil
    }

}
