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
            if self.isSelected {
                self.sectionNameLabel.textColor = .white
                self.colorView.backgroundColor = .black
            } else {
                self.sectionNameLabel.textColor = .black
                self.colorView.backgroundColor = .white
            }
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
