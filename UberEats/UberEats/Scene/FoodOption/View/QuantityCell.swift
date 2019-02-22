//
//  QuantityCell.swift
//  UberEats
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class QuantityCell: UITableViewCell {

    @IBOutlet weak var quantityControlView: QuantityControlView!

    weak var quantitychanged: QuantityValueChanged? {
        get {
            return quantityControlView?.quantitychanged
        }
        set {
            quantityControlView?.quantitychanged = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
