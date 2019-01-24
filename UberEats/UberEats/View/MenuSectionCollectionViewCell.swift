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
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
