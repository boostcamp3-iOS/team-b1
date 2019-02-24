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

    var sectionName: String? {
        didSet {
            guard let sectionName = sectionName else {
                return
            }

            sectionNameLabel.text = sectionName
        }
    }

    func setColor(by isSelected: Bool) {
        sectionNameLabel?.textColor = isSelected ? .white : .black
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //sectionNameLabel.textColor = .black
        //sectionName = nil
    }
}
