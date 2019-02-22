//
//  SeeMoreRestTableViewCell.swift
//  UberEats
//
//  Created by admin on 30/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class SeeMoreRestTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var promotion: UILabel!

    @IBOutlet weak var deliveryTime: UILabel!

    var moreRests: StoreForView? {
        didSet {

            guard let moreRest = moreRests else {
                return
            }

            name.text = moreRest.name
            category.text = moreRest.category
            deliveryTime.text = moreRest.deliveryTime
        }
    }

    var moreFoods: FoodForView? {
        didSet {
            guard let moreFood = moreFoods else {
                return
            }

            name.text = moreFood.foodName
            category.text = moreFood.categoryName
            deliveryTime.text = moreFood.foodDescription
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        mainImage.layer.cornerRadius = 3
        mainImage.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        mainImage.image = UIImage(named: "foodPlaceHolder")
    }

}
