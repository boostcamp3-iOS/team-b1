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

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var view: UIView!

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var minuteLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!

    var storeInfo: StoreForView? {
        didSet {
            guard let storeInfo = storeInfo else {
                return
            }

            categoryLabel.text = storeInfo.category
            minuteLabel.text = storeInfo.deliveryTime + "분"

            gradeLabel.text = String(storeInfo.rate.score)
                                + " ★ " + String(storeInfo.rate.numberOfRater)
        }
    }

    var recommendFood: FoodForView? {
        didSet {
            guard let recommendFood = recommendFood else {
                return
            }

            label.text = recommendFood.foodName
            commentLabel.text = recommendFood.foodDescription

        }
    }

    func isExistFoodDescription() -> CGFloat {
        guard let recommendFood = recommendFood else {
            return 260
        }
        if recommendFood.foodDescription == "" {
            commentLabel.isHidden = true
            return 260
        } else {
            commentLabel.isHidden = false
            return 280.46875
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
