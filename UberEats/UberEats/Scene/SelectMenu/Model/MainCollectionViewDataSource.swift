//
//  MainCollectionViewDataSource.swift
//  UberEats
//
//  Created by 이혜주 on 02/03/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var store: StoreForView
    var foods: [FoodForView]
    var categorys: [String]
    var categoryOfFood: [String: [FoodForView]]

    init(store: StoreForView,
         foods: [FoodForView],
         categorys: [String],
         categoryOfFood: [String: [FoodForView]]) {
        self.store = store
        self.foods = foods
        self.categorys = categorys
        self.categoryOfFood = categoryOfFood
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return store.numberOfCategory + DistanceBetween.menuAndRest
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1, 2:
            return basicNumberOfItems
        default:
            let categoryId: String = "category"
                                     + String(section - DistanceBetween.menuAndRest + 1)

            guard let food = categoryOfFood[categoryId]?.count else {
                return 0
            }

            return food + DistanceBetween.titleAndFoodCell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            return collectionView.dequeueReusableCell(for: indexPath) as TimeAndLocationCollectionViewCell
        case 2:
            return collectionView.dequeueReusableCell(for: indexPath) as SearchCollectionViewCell
        default:
            switch indexPath.item {
            case 0:
                let cell =
                    collectionView.dequeueReusableCell(for: indexPath) as MenuSectionCollectionViewCell

                cell.configure(categoryName: categorys[indexPath.section - DistanceBetween.menuAndRest])

                return cell
            default:
                let cell = collectionView.dequeueReusableCell(for: indexPath) as FoodCollectionViewCell

                let categoryId: String = "category"
                                         + String(indexPath.section - DistanceBetween.menuAndRest + 1)
                let foodIndex: Int = indexPath.item - DistanceBetween.titleAndFoodCell

                guard let food: FoodForView = categoryOfFood[categoryId]?[foodIndex] else {
                    return cell
                }

                cell.configure(food: food)

                guard let imageURL = URL(string: food.lowImageURL) else {
                    return cell
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak cell] (image, error) in
                    if error != nil {
                        return
                    }

                    guard cell?.imageURL == imageURL.absoluteString else {
                        return
                    }

                    cell?.foodImageView.image = image
                }

                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {

            switch indexPath.section {
            case 0:
                let header =
                    collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                    kind: kind) as StretchyHeaderView

                guard let imageURL = URL(string: store.mainImage) else {
                        return header
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak header] (image, error) in
                    if error != nil {
                        return
                    }

                    header?.headerImageView.image = image
                }

                return header
            default:
                return collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                       kind: kind)
            }
        } else {
            let footer =
                collectionView.dequeueReusableSupplementaryView(for: indexPath,
                                                                kind: kind) as TempCollectionReusableView

            footer.backgroundColor = #colorLiteral(red: 0.8638877273, green: 0.8587527871, blue: 0.8678352237, alpha: 1)

            return footer
        }
    }
}
