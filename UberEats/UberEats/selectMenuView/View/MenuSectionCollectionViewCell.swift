//
//  menuSectionCollectionViewCell.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 24/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class MenuSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var colorView: UIView!

    override var isSelected: Bool {
        didSet {
            self.sectionNameLabel.textColor = self.isSelected ? .white : .black
        }
    }

    var sectionName: String? {
        didSet {
            guard let sectionName = sectionName else {
                return
            }

            sectionNameLabel.text = sectionName
            colorView.layer.cornerRadius = 20
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        colorView.backgroundColor = .white
        sectionNameLabel.textColor = .black
        sectionName = nil
    }
}
