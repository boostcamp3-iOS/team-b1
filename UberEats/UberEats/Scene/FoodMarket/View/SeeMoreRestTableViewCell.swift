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

    var confirmURL: URL?

    var moreRests: StoreForView? {
        didSet {

            guard let moreRest = moreRests else {
                return
            }

            guard let cellURL = URL(string: moreRest.mainImage) else {
                return
            }
            name.text = moreRest.name
            category.text = moreRest.category
            deliveryTime.text = moreRest.deliveryTime
            promotion.text = moreRest.promotion

            confirmURL = cellURL
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
        name.text = ""
        category.text = ""
        rate.text = ""
        promotion.text = ""
        deliveryTime.text = ""
        mainImage.image = UIImage(named: "foodPlaceHolder")
    }

}
