//
//  menuSectionCollectionViewCell.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 24/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class MenuCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!

    func setColor(by isSelected: Bool) {
        sectionNameLabel?.textColor = isSelected ? .white : .black
    }

    func configure(sectionName: String) {
        sectionNameLabel.text = sectionName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
