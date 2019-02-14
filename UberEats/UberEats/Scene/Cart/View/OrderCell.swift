//
//  OrderCell.swift
//  UberEats
//
//  Created by 장공의 on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var amountLable: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var order: OrderInfoModel! {
        didSet {
            amountLable.text = String(order.amount)
            orderNameLabel.text = order.orderName
            priceLabel.text = "$\(order.price)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
