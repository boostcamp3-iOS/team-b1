//
//  SmallMenuHeaderView.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class MenuSectionView: UICollectionReusableView {

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
        menuLabel.text = nil
    }
}
