//
//  CollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 06/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
