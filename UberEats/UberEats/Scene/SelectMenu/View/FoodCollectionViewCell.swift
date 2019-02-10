//
//  FoodCollectionViewCell.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {

    let foodNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    let foodContentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
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
        imageView.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        return imageView
    }()

    var food: Food? {
        didSet {
            guard let food = food else {
                return
            }

            foodNameLabel.text = food.foodName
            foodContentsLabel.text = food.foodContents
            priceLabel.text = food.price
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    func setupLayout() {
        addSubview(foodNameLabel)
        addSubview(foodContentsLabel)
        addSubview(priceLabel)
        addSubview(foodImageView)

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
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            foodImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            foodImageView.widthAnchor.constraint(equalToConstant: 100),
            foodImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
