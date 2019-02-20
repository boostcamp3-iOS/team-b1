//
//  MenuSectionCollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 18/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class MenuSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var menuLabel: UILabel!

    var menuTitle: String? {
        didSet {
            guard let menuTitle = self.menuTitle else {
                return
            }

            menuLabel.text = menuTitle
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        menuLabel.text = nil
    }

}
