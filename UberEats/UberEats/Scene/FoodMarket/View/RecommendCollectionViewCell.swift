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

    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var star: UIImageView!

    var confirmURL: URL?

    private let smallCellHeight: CGFloat = 245
    private let bigCellHeight: CGFloat = 269

    var recommendFood: FoodForView? {
        didSet {
            guard let recommendFood = recommendFood else {
                return
            }
            label.text = recommendFood.foodName
            commentLabel.text = recommendFood.foodDescription
            categoryLabel.text = recommendFood.categoryName

            guard let cellURL = URL(string: recommendFood.foodImageURL) else {
                return
            }

            if recommendFood.foodDescription == "" {
                self.starStackView.isHidden = true
            } else {
                self.starStackView.isHidden = false
            }

            confirmURL = cellURL

        }
    }

    func isExistFoodDescription() -> CGFloat {
        guard let recommendFood = recommendFood else {
            return smallCellHeight
        }
        if recommendFood.foodDescription == "" {
            return smallCellHeight
        } else {
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

        image.layer.cornerRadius = 3
        image.layer.masksToBounds = true
    }
}
