//
//  RequiredOptionsCell.swift
//  UberEats
//
//  Created by 장공의 on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class RequiredOptionsCell: UITableViewCell, HavingFoodOptionCategory {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var supportingExplanationLabel: UILabel!

    var foodOptionCategoryModel: FoodOptionsCategory! {
        didSet {
            nameLabel.text = foodOptionCategoryModel.name
            supportingExplanationLabel.text = foodOptionCategoryModel.supportingExplanation
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
