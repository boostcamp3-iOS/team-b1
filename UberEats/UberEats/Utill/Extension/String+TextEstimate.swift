//
//  String+TextEstimate.swift
//  UberEats
//
//  Created by 이혜주 on 11/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension String {

    var estimateCGRect: CGRect {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        return NSString(string: self).boundingRect(with: size,
                                                   options: option,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }

    func getEstimateCGRectWith(_ fontSize: CGFloat) -> CGRect {
        let width = UIScreen.main.bounds.width - 135
        let size = CGSize(width: width, height: 500)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        return NSString(string: self).boundingRect(with: size,
                                                   options: option,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)],
                                                   context: nil)
    }
}
