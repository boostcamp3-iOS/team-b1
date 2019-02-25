//
//  StoreCollectionViewController+DataSource.swift
//  UberEats
//
//  Created by 이혜주 on 25/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common
import Service
import DependencyContainer
import ServiceInterface

extension StoreCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == menuBarCollectionView {
            return NumberOfSection.menuBar.rawValue
        } else {
            guard let numberOfCategory: Int = store?.numberOfCategory else {
                return 0
            }
            return numberOfCategory + DistanceBetween.menuAndRest
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuBarCollectionView {
            return categorys.count
        }

        switch section {
        case 0:
            return 0
        case 1, 2:
            return basicNumberOfItems
        default:
            let categoryId: String = "category" + String(section - DistanceBetween.menuAndRest + 1)
            guard let food = foodsOfCategory[categoryId]?.count else {
                return 0
            }
            return food + DistanceBetween.titleAndFoodCell
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuBarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuCategory.rawValue,
                                                                for: indexPath) as? MenuCategoryCollectionViewCell else {
                                                                    return .init()
            }

            collectionView.sendSubviewToBack(floatingView)

            cell.sectionName = categorys[indexPath.item]
            cell.setColor(by: collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false)

            return cell
        }

        switch indexPath.section {
        case 1:
            identifier = CellId.timeAndLocation.rawValue
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menu.rawValue,
                                                                for: indexPath) as? SearchCollectionViewCell else {
                                                                    return .init()
            }

            cell.searchBarDelegate = self

            return cell
        default:
            switch indexPath.item {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuSection.rawValue,
                                                                    for: indexPath) as? MenuSectionCollectionViewCell else {
                                                                        return .init()
                }

                cell.menuLabel.text = categorys[indexPath.section - DistanceBetween.menuAndRest]

                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.menuDetail.rawValue,
                                                                    for: indexPath) as? FoodCollectionViewCell else {
                                                                        return .init()
                }

                let categoryId: String = "category" + String(indexPath.section - DistanceBetween.menuAndRest + 1)
                let foodIndex: Int = indexPath.item - DistanceBetween.titleAndFoodCell

                guard let food: FoodForView = foodsOfCategory[categoryId]?[foodIndex] else {
                    return cell
                }

                cell.priceLabelBottomConstraint.isActive = (food.foodDescription == "") ? false : true
                cell.foodImageViewWidthConstraint.constant = (food.lowImageURL == "") ? 0 : 100

                cell.food = food

                guard let imageURL = URL(string: food.lowImageURL) else {
                    return cell
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak cell] (image, error) in
                    if error != nil {
                        return
                    }

                    guard cell?.food?.lowImageURL == imageURL.absoluteString else {
                        return
                    }

                    cell?.foodImageView.image = image
                }

                return cell
            }
        }

        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            if collectionView == menuBarCollectionView {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                             for: indexPath)
                return header
            }

            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.stretchyHeader.rawValue,
                                                                                   for: indexPath) as? StretchyHeaderView else {
                                                                                    return .init()
                }

                guard let imageURLString = store?.mainImage,
                    let imageURL = URL(string: imageURLString) else {
                        return header
                }

                ImageNetworkManager.shared.getImageByCache(imageURL: imageURL) { [weak header] (image, error) in
                    if error != nil {
                        return
                    }

                    header?.headerImageView.image = image
                }

                return header

            case 1, 2:
                identifier = CellId.tempHeader.rawValue
            default:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: CellId.tempHeader.rawValue,
                                                                       for: indexPath)
            }
        } else {
            if collectionView == self.collectionView {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: CellId.tempFooter.rawValue,
                                                                                   for: indexPath) as? TempCollectionReusableView else {
                                                                                    return .init()
                }

                footer.backgroundColor = #colorLiteral(red: 0.8638877273, green: 0.8587527871, blue: 0.8678352237, alpha: 1)

                return footer
            }
        }

        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: identifier,
                                                               for: indexPath)
    }

}
