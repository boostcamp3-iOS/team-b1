//
//  ExpectTimeCollectionViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class ExpectTimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var promotion: UILabel!

    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var starStackView: UIStackView!

    @IBOutlet weak var rater: UILabel!
    private let smallCellHeight: CGFloat = 248
    private let bigCellHeight: CGFloat = 269

    var confirmURL: URL?

    var expectTimeRest: StoreForView? {
        didSet {
            guard let expectTimeRest = expectTimeRest else {
                return
            }

            guard let cellURL = URL(string: expectTimeRest.mainImage) else {
                return
            }

            name.text = expectTimeRest.name
            category.text = expectTimeRest.category
            deliveryTime.text = "\(expectTimeRest.deliveryTime) 분"
            rate.text = "\(expectTimeRest.rate.score)"
            promotion.text = expectTimeRest.promotion
            rater.text = "(\(expectTimeRest.rate.numberOfRater))"

            if expectTimeRest.promotion == "" {
                starStackView.isHidden = true
            } else {
                starStackView.isHidden = false
            }

            confirmURL = cellURL

        }
    }

    func isExistPromotion() -> CGFloat {
        guard let expectTimeRest = expectTimeRest else {
            return smallCellHeight
        }
        if expectTimeRest.promotion == "" {
            promotion.isHidden = true
            return smallCellHeight
        } else {
            promotion.isHidden = false
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

        mainImage.layer.cornerRadius = 3
        mainImage.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        mainImage.image = UIImage(named: "foodPlaceHolder")
    }

}
