//
//  StoreCollectionViewController+ScrollDelegate.swift
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

    // MARK: - ScrollView
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != menuBarCollectionView {

            let likeButtonImage = UIImage(named: getLikeButtonImageName(scrollView.contentOffset.y))

            likeButton.setImage(likeButtonImage, for: .normal)

            if scrollView.contentOffset.y > AnimationValues.scrollLimit
                && backButton.currentImage == UIImage(named: "arrow") {

                collectionView.contentInset
                    = UIEdgeInsets(top: storeTitleView.frame.height - 30,
                                   left: ValuesForCollectionView.menuBarZeroInset,
                                   bottom: ValuesForCollectionView.menuBarZeroInset,
                                   right: ValuesForCollectionView.menuBarZeroInset)

                UIView.animate(withDuration: AnimationValues.duration,
                               delay: AnimationValues.delay,
                               options: .curveEaseIn,
                               animations: { [weak self] in
                                   self?.backButton.setImage(UIImage(named: "blackArrow"), for: .normal)
                                   self?.menuBarCollectionView.alpha = ValuesForCollectionView.menuBarFullAlpha
                               }, completion: { [weak self] _ in
                                   self?.statusBarStyle = .default
                })

            } else if scrollView.contentOffset.y < AnimationValues.scrollLimit
                && backButton.currentImage == UIImage(named: "blackArrow") {

                collectionView.contentInset
                    = UIEdgeInsets(top: ValuesForCollectionView.menuBarZeroInset,
                                   left: ValuesForCollectionView.menuBarZeroInset,
                                   bottom: ValuesForCollectionView.menuBarZeroInset,
                                   right: ValuesForCollectionView.menuBarZeroInset)

                UIView.animate(withDuration: AnimationValues.duration,
                               delay: AnimationValues.delay,
                               options: .curveEaseIn, animations: { [weak self] in
                                   self?.backButton.setImage(UIImage(named: "arrow"), for: .normal)
                                   self?.menuBarCollectionView.alpha = ValuesForCollectionView.menuBarZeroAlpha
                               }, completion: { [weak self] _ in
                                   self?.statusBarStyle = .lightContent
                })
            }

            setNeedsStatusBarAppearanceUpdate()
            view.layoutIfNeeded()
            handleStoreView(by: scrollView)

            // collectionView.frame.width * 0.9 * 0.5 - 38 => storeTitleView의 높이
            let yPoint = collectionView.contentOffset.y
                         + collectionView.frame.width
                         * ValuesForStoreView.widthMultiplier
                         * ValuesForStoreView.heightMultiplier
                         - ValuesForStoreView.distanceBetweenHeightAfterStick + 15

            guard let currentSection
                = collectionView.indexPathForItem(at: CGPoint(x: 100,
                                                              y: yPoint))?.section else {
                return
            }

            isChangedSection = (lastSection != currentSection)

            if currentSection >= menuStartSection && isChangedSection && isScrolling {
                let lastIndexPath = IndexPath(item: lastSection - DistanceBetween.menuAndRest,
                                              section: 0)
                collectionView(menuBarCollectionView,
                               didDeselectItemAt: lastIndexPath)

                let indexPathToMove = IndexPath(item: currentSection - DistanceBetween.menuAndRest,
                                                section: 0)
                collectionView(menuBarCollectionView,
                               didSelectItemAt: indexPathToMove)

                lastSection = currentSection
            }
        }

    }

    private func getLikeButtonImageName(_ offsetY: CGFloat) -> String {
        if offsetY > AnimationValues.likeButtonChangeLimit {
            return "search"
        } else {
            return isLiked ? "selectLike" : "like"
        }
    }
}

extension StoreCollectionViewController {
    private func handleStoreView(by scrollView: UIScrollView) {
        let currentScroll: CGFloat = scrollView.contentOffset.y
        let headerHeight: CGFloat = HeightsOfHeader.stretchy

        changedContentOffset(currentScroll: currentScroll,
                             headerHeight: headerHeight)
    }

    private func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        storeTitleView.changedContentOffset(currentScroll: currentScroll,
                                            headerHeight: headerHeight)
        view.layoutIfNeeded()
    }
}
