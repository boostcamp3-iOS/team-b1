//
//  NearestCollectionViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class NearestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var promotion: UILabel!

    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var starStackView: UIStackView!

    @IBOutlet weak var rater: UILabel!
    @IBOutlet weak var star: UIImageView!
    var confirmURL: URL?

    private let smallCellHeight: CGFloat = 245
    private let bigCellHeight: CGFloat = 269

    var nearestRest: StoreForView? {
        didSet {
            guard let restaurant = nearestRest else {
                return
            }

            name.text = restaurant.name
            category.text = restaurant.category
            deliveryTime.text = "\(restaurant.deliveryTime) 분"
            promotion.text = restaurant.promotion
            price.text = "\(restaurant.rate.score)"
            rater.text = "(\(restaurant.rate.numberOfRater))"

            guard let cellURL = URL(string: restaurant.mainImage) else {
                return
            }

            if restaurant.promotion == "" {
                starStackView.isHidden = true
            } else {
                starStackView.isHidden = false
            }

            confirmURL = cellURL
        }
    }

    func isExistPromotion() -> CGFloat {
        guard let nearestRest = nearestRest else {
            return smallCellHeight
        }
        if nearestRest.promotion == "" {
            promotion.isHidden = true
            return smallCellHeight
        } else {
            promotion.isHidden = false
            return bigCellHeight
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        star.image = UIImage(named: "star")

        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0

        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        mainImage.layer.cornerRadius = 3
        mainImage.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        name.text = ""
        category.text = ""
        deliveryTime.text = ""
        promotion.text = ""
        mainImage.image = UIImage(named: "foodPlaceHolder")
    }
}
