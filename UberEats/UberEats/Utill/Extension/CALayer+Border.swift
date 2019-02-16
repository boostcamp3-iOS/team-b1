//
//  CALayer+Border.swift
//  UberEats
//
//  Created by 장공의 on 12/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

extension CALayer {
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {

            case UIRectEdge.top:
                border.frame = .init(x: 0, y: 0, width: frame.width, height: width)
                break

            case UIRectEdge.bottom:
                border.frame = .init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break

            case UIRectEdge.left:
                border.frame = .init(x: 0, y: 0, width: width, height: frame.height)
                break

            case UIRectEdge.right:
                border.frame = .init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break

            default:
                break

            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }

}
