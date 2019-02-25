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

    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var starStackView: UIStackView!

    @IBOutlet weak var rater: UILabel!

    @IBOutlet weak var rate: UILabel!

    private let smallCellHeight: CGFloat = 260
    private let bigCellHeight: CGFloat = 269

    var newRest: StoreForView? {
        didSet {
            guard let newRests = newRest else {
                return
            }

            guard let cellURL = URL(string: newRests.mainImage) else {
                return
            }

            if newRests.promotion == "" {
                starStackView.isHidden = true
            } else {
                starStackView.isHidden = false
            }

            name.text = newRests.name
            category.text = newRests.category
            deliveryTime.text = "\(newRests.deliveryTime) 분"
            promotion.text = newRests.promotion
            rate.text = "\(newRests.rate.score)"
            rater.text = "(\(newRests.rate.numberOfRater))"

            confirmURL = cellURL
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()

        star.image = UIImage(named: "star")

        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0

        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        mainImage.layer.cornerRadius = 3
        mainImage.layer.masksToBounds = true
    }

    func isExistPromotion() -> CGFloat {
        guard let newRest = newRest else {
            return smallCellHeight
        }
        if newRest.promotion == "" {
            promotion.isHidden = true
            return smallCellHeight
        } else {
            promotion.isHidden = false
            return bigCellHeight
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
