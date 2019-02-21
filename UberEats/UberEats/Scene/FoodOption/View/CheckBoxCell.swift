//
//  CheckBoxCell.swift
//  UberEats
//
//  Created by 장공의 on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class CheckBoxCell: UITableViewCell, HavingFoodOptionItem {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var foodOptionItemModel: FoodOptionItem! {
        didSet {
            nameLable.text = foodOptionItemModel.name
            priceLabel.text = "+₩\(foodOptionItemModel.price)"
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
