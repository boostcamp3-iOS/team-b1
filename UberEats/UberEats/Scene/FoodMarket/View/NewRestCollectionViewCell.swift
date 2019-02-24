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
    @IBOutlet weak var promotion: UILabel!

    var confirmURL: URL?

    var newRest: StoreForView? {
        didSet {
            guard let newRests = newRest else {
                return
            }

            guard let cellURL = URL(string: newRests.mainImage) else {
                return
            }

            name.text = newRests.name
            category.text = newRests.category
            deliveryTime.text = newRests.deliveryTime
            promotion.text = newRests.promotion

            confirmURL = cellURL
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

    func isExistPromotion() -> CGFloat {
        guard let newRest = newRest else {
            return 260
        }
        if newRest.promotion == "" {
            promotion.isHidden = true
            return 260
        } else {
            promotion.isHidden = false
            return 272
        }
    }

    override func prepareForReuse() {
        name.text = ""
        category.text = ""
        deliveryTime.text = ""
        promotion.text = ""
        mainImage.image = UIImage(named: "foodPlaceHolder")
    }
}
