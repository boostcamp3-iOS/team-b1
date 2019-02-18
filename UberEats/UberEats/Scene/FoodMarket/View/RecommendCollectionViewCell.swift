//
//  RecommendCollectionViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class RecommendCollectionViewCell: UICollectionViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var view: UIView!

    @IBOutlet var bugerLabel: UILabel!
    @IBOutlet var minuteLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!

    var recommendFood: Food? {
        didSet {
            guard let recommendFood = recommendFood else {
                return
            }

            label.text = recommendFood.foodName
            commentLabel.text = recommendFood.foodDescription

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0

        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        image.layer.cornerRadius = 3
        image.layer.masksToBounds = true
    }
}
