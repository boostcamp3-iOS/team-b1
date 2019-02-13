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
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
