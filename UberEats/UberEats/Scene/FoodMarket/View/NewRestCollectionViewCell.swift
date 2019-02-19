//
//  NewRestCollectionViewCell.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class NewRestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    //rate
    @IBOutlet weak var promotion: UILabel!

    var newRest: Store? {
        didSet {
            guard let newRest = newRest else {
                return
            }

            name.text = newRest.name
            category.text = newRest.category
            deliveryTime.text = newRest.deliveryTime
            promotion.text = newRest.promotion

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

    override func prepareForReuse() {
        name.text = ""
        category.text = ""
        deliveryTime.text = ""
        promotion.text = ""
    }
}
