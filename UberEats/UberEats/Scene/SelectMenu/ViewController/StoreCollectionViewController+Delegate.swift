//
//  StoreCollectionViewController+Delegate.swift
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        if collectionView == menuBarCollectionView {
            return .init(width: 0, height: HeightsOfHeader.menuBarAndMenu)
        }

        switch section {
        case 0:
            return .init(width: view.frame.width,
                         height: HeightsOfHeader.stretchy)
        default:
            return .init(width: view.frame.width,
                         height: HeightsOfHeader.food)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if section > 2 {
            return .init(width: view.frame.width,
                         height: 0.5)
        }

        return .init(width: 0, height: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuBarCollectionView {

            movingFloatingView(collectionView, indexPath)

            if !isScrolling {
                let sectionIndex: Int = indexPath.item + DistanceBetween.menuAndRest
                let indexToMove = IndexPath(item: 0, section: sectionIndex)
                self.collectionView.selectItem(at: indexToMove, animated: true, scrollPosition: .top)
            }
        } else {
            switch indexPath.section {
            case 0, 1, 2:
                return
            default:
                if indexPath.item == 0 {
                    return
                }

                let foodOptionStoryboard = UIStoryboard(name: "FoodItemDetails", bundle: nil)
                guard let foodOptionViewController = foodOptionStoryboard.instantiateViewController(withIdentifier: "FoodItemDetailsVC")
                    as? FoodItemDetailsViewController else {
                        return
                }

                foodOptionViewController.foodSelectable = self

                let food = foods[indexPath.item - 1]
                foodOptionViewController.foodInfo = FoodInfoModel.init(name: food.foodName,
                                                                       supportingExplanation: food.foodDescription,
                                                                       price: food.basePrice,
                                                                       imageURL: food.foodImageURL)

                navigationController?.pushViewController(foodOptionViewController, animated: true)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCategoryCollectionViewCell else {
            return
        }

        cell.setColor(by: false)
    }

    private func movingFloatingView(_ collectionView: UICollectionView, _ indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCategoryCollectionViewCell else {
            return
        }

        // 위에 검은 뷰가 셀을 가리기 때문에 글씨가 보이지 않게 되는 문제를 해결하기 위해
        // cell을 가장 상위로 이동시킨다.
        collectionView.bringSubviewToFront(cell)

        let estimatedForm = categorys[indexPath.item].estimateCGRect

        floatingViewWidthConstraint.constant = estimatedForm.width + ValuesForFloatingView.widthPadding

        floatingViewLeadingConstraint.constant = cell.frame.minX

        UIView.animate(withDuration: AnimationValues.duration,
                       delay: AnimationValues.delay,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.menuBarCollectionView.layoutIfNeeded()
            }, completion: nil)

        cell.setColor(by: true)

        // 선택한 셀을 가장 왼쪽으로 붙게 설정
        let sectionIndx = IndexPath(item: indexPath.item, section: 0)
        collectionView.selectItem(at: sectionIndx, animated: true, scrollPosition: .left)

    }
}
