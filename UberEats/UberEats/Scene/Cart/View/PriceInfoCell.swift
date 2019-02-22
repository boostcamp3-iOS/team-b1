//
//  PriceInfoCell.swift
//  UberEats
//
//  Created by 장공의 on 17/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class PriceInfoCell: UITableViewCell {

    @IBOutlet weak var subPriceLable: UILabel!
    @IBOutlet weak var priceLable: UILabel!

    var priceInfo: PriceInfoModel! {
        didSet {
            priceLable.text = "￦\(priceInfo.price.formattedWithSeparator)"
            subPriceLable.text = "￦\(priceInfo.subPrice.formattedWithSeparator)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
