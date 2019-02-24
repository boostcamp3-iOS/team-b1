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

    var confirmURL: URL?

    var nearestRest: StoreForView? {
        didSet {
            guard let restaurant = nearestRest else {
                return
            }

            name.text = restaurant.name
            category.text = restaurant.category
            deliveryTime.text = restaurant.deliveryTime
            promotion.text = restaurant.promotion

            guard let cellURL = URL(string: restaurant.mainImage) else {
                return
            }

            confirmURL = cellURL
        }
    }

    func isExistPromotion() -> CGFloat {
        guard let nearestRest = nearestRest else {
            return 260
        }
        if nearestRest.promotion == "" {
            promotion.isHidden = true
            return 260
        } else {
            promotion.isHidden = false
            return 272
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

        mainImage.image = nil
    }

    override func prepareForReuse() {
        name.text = ""
        category.text = ""
        deliveryTime.text = ""
        promotion.text = ""
        mainImage.image = UIImage(named: "foodPlaceHolder")
    }
}
