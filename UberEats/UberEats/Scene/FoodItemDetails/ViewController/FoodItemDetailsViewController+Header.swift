//
//  FoodItemDetailsViewController+Header.swift
//  UberEats
//
//  Created by 장공의 on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension FoodItemDetailsViewController {

    private func getStretchableHeaderMinumumHeight() -> CGFloat {
        return self.toolbar.frame.height
    }

    private func getStretchableHeaderMaximumHeight() -> CGFloat {
        return self.view.frame.height
    }

    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let stretchableHeaderY = -scrollView.contentOffset.y

        let height = min(max(stretchableHeaderY, getStretchableHeaderMinumumHeight()), getStretchableHeaderMaximumHeight())

        stretchableHeaderHeight.constant = height
        changeStatusWithCoveredToolbar(height)
    }

    private func changeStatusWithCoveredToolbar(_ stretchableHeaderHeight: CGFloat) {

        func coveredToolBarStatus() -> CoveredToolBarStatus {
            if stretchableHeaderHeight <= getStretchableHeaderMinumumHeight() {
                return .covered
            }
            return .uncovered
        }

        func coveredToolBarHeight(status: CoveredToolBarStatus) -> CGFloat {
            return coveredToolBarStatus() == .uncovered ? -self.toolbar.frame.height : 0
        }

        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.coveredToolBarBottom.constant = coveredToolBarHeight(status: coveredToolBarStatus())
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}
