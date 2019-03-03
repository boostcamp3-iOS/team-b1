//
//  MenuCollectionViewDataSource.swift
//  UberEats
//
//  Created by 이혜주 on 02/03/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class MenuCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var categorys: [String]

    init(categorys: [String]) {
        self.categorys = categorys
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return NumberOfSection.menuBar.rawValue
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(for: indexPath) as MenuCategoryCollectionViewCell

        cell.configure(sectionName: categorys[indexPath.item])
        cell.setColor(by: collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false)

        return cell
    }
}
