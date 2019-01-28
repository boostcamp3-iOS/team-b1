//
//  StretchyHeaderLayout.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    var itemSizeDelegate: ItemSizeDelegate?
    var lastContentOffsetY: CGFloat = 0

    // 헤더 구성요소의 속성을 수정하려고 한다.
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // layoutAttributesForElements(in:) -> Returns the layout attributes for all of the cells and views in the specified rectangle.
        let layoutAttributes = super.layoutAttributesForElements(in: rect)

        layoutAttributes?.forEach({ (attributes) in
            // 0번째 섹션의 헤더일 경우만
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader && attributes.indexPath.section == 0 {

                guard let collectionView = collectionView else { return }

                let contentOffsetY = collectionView.contentOffset.y
                
                itemSizeDelegate?.changedContentOffset(curOffsetY: contentOffsetY, lastOffsetY: lastContentOffsetY)
                if contentOffsetY > 0 {
                    // 200보다 크면 고정
                    if contentOffsetY > 200 {
                        attributes.frame.origin.y = collectionView.contentOffset.y - 200
                    }
                    lastContentOffsetY = contentOffsetY
//                    return
                }

                let width = collectionView.frame.width

                // 스크롤한만큼 높이를 더한다.
                let height = attributes.frame.height - contentOffsetY

                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
        })
        return layoutAttributes
    }

    // 아마두 경계를 계속 업데이트 해주기 위해서 사용하는듯
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
