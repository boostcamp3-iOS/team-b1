//
//  StretchyHeaderLayout.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    var lastContentOffsetY: CGFloat = 0

    // 아마두 경계를 계속 업데이트 해주기 위해서 사용하는듯
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
