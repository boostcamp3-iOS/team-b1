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
        let label = UILabel().setupWithFontSize(Metrix.foodNameLabelFontSize)
        label.numberOfLines = Metrix.labelNumberOfLine
        return label
    }()

    let foodContentsLabel: UILabel = {
        let label = UILabel().setupWithFontSize(Metrix.foodContentsAndPriceLabelFontSize)
        label.numberOfLines = Metrix.labelNumberOfLine
        label.textColor = .gray
        return label
    }()

    let priceLabel = UILabel().setupWithFontSize(Metrix.foodContentsAndPriceLabelFontSize)

    let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "foodPlaceHolder")
        imageView.layer.borderColor = #colorLiteral(red: 0.8979219198, green: 0.8925844431, blue: 0.9020249844, alpha: 1)
        imageView.layer.borderWidth = 0.5
        return imageView
    }()

    var food: FoodForView? {
        didSet {
            guard let food = food else {
                return
            }

            foodNameLabel.text = food.foodName
            foodContentsLabel.text = food.foodDescription
            priceLabel.text = "￦" + food.basePrice.formattedWithSeparator
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    private func setupLayout() {
        backgroundColor = .white
        addSubview(foodNameLabel)
        addSubview(foodContentsLabel)
        addSubview(priceLabel)
        addSubview(foodImageView)

        priceLabelBottomConstraint = NSLayoutConstraint(item: priceLabel,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: -10)
        priceLabelBottomConstraint.isActive = true

        foodImageViewWidthConstraint = foodImageView.widthAnchor.constraint(equalToConstant: Metrix.imageViewWidth)
        foodImageViewWidthConstraint.isActive = true

        NSLayoutConstraint.activate([
            foodNameLabel.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Metrix.topMargin),
            foodNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Metrix.leadingMargin),
            foodNameLabel.trailingAnchor.constraint(equalTo: foodImageView.leadingAnchor,
                                                    constant: -Metrix.trailingMargin),

            foodContentsLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor,
                                                   constant: Metrix.topMargin),
            foodContentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                       constant: Metrix.leadingMargin),
            foodContentsLabel.trailingAnchor.constraint(equalTo: foodImageView.leadingAnchor,
                                                        constant: -Metrix.trailingMargin),

            priceLabel.topAnchor.constraint(equalTo: foodContentsLabel.bottomAnchor,
                                            constant: Metrix.topMargin),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: Metrix.leadingMargin),
            priceLabel.trailingAnchor.constraint(equalTo: foodImageView.leadingAnchor,
                                                 constant: -Metrix.trailingMargin),

            foodImageView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Metrix.topMargin),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -Metrix.trailingMargin),
            foodImageView.heightAnchor.constraint(equalToConstant: Metrix.imageViewHeight)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        foodNameLabel.text = ""
        foodContentsLabel.text = ""
        priceLabel.text = ""
        foodImageView.image = nil
    }

}

private struct Metrix {
    static let foodNameLabelFontSize: CGFloat = 18
    static let foodContentsAndPriceLabelFontSize: CGFloat = 15
    static let topMargin: CGFloat = 10
    static let leadingMargin: CGFloat = 15
    static let trailingMargin: CGFloat = 10
    static let imageViewWidth: CGFloat = 100
    static let imageViewHeight: CGFloat = 90
    static let labelNumberOfLine: Int = 2
}
