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

    var delegate: ChangeScrollDelegate?

    var delivererInfo: DelivererInfo? {
        didSet {
            guard let delivererInfo = delivererInfo else {
                return
            }

            deliveryManImageView.image = delivererInfo.image
            deliveryManNameLabel.text = delivererInfo.name
            vehicleLabel.text = delivererInfo.vehicle
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    private func setupLayout() {
        deliveryManImageView.layer.cornerRadius = 25
        isHidden = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.scrollToTop()
    }
}
