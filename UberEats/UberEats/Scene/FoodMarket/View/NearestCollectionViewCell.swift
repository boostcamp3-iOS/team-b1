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

    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var deliveryTime: UILabel!
    @IBOutlet var promotion: UILabel!

    var nearestRest: Store? {
        didSet {
            guard let restaurant = nearestRest else {
                return
            }

            name.text = restaurant.name
            category.text = restaurant.category
            deliveryTime.text = restaurant.deliveryTime
            promotion.text = restaurant.promotion
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0

        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        mainImage.layer.cornerRadius = 3
        mainImage.layer.masksToBounds = true
    }

}
