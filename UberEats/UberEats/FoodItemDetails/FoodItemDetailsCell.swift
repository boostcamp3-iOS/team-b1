//
//  FoodItemDetailsCell.swift
//  UberEats
//
//  Created by 장공의 on 27/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class FoodItemDetailsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    // aleary description
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
