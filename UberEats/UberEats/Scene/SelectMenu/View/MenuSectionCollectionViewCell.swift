//
//  MenuSectionCollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 18/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class MenuSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!

    func configure(categoryName: String) {
        categoryNameLabel.text = categoryName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        categoryNameLabel.text = nil
    }

}
