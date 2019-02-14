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

            let imageURL = URL(string: restaurant.mainImage)!

            ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak self] (downloadImage, _) in
                self?.mainImage.image = downloadImage
            }

            name.text = restaurant.name
            category.text = restaurant.category
            deliveryTime.text = restaurant.deliveryTime
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0

        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = true

        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath

    }

}
