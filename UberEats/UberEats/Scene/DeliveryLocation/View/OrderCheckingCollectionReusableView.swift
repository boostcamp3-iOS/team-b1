//
//  OrderCheckingCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderCheckingCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeTitleLabel: UILabel!
    @IBOutlet weak var currentProgressSlider: UISlider!
    @IBOutlet weak var currentProgressLabel: UILabel!

    var delegate: ChangeScrollDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.scrollToTop()
    }
}
