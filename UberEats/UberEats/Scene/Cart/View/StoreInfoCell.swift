//
//  StoreInfoCell.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class StoreInfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!

    var storeInfo: StoreInfoModel! {
        didSet {
            nameLabel.text = storeInfo.name
            deliveryTimeLabel.text = storeInfo.deliveryTime
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        hideSeparator()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
