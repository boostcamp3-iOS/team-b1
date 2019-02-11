//
//  DeliveryManInfoCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class DeliveryManInfoCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var deliveryManImageView: UIImageView!
    @IBOutlet weak var deliveryManNameLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    private func setupLayout() {
        deliveryManImageView.layer.cornerRadius = 25
        deliveryManNameLabel.text = "수근 (99% 👍🏻)"
        vehicleLabel.text = "우버 Moterbike"
    }
}
