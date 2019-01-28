//
//  SearchCollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    var searchBarDelegate: SearchBarDelegate?

    @IBAction func touchUpSearchButton(_ sender: Any) {
        print("touchUpSearchButton")
        searchBarDelegate?.showSeachBar()
    }

}
