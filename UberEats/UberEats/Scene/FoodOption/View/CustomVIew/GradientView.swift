//
//  GradientView.swift
//  UberEats
//
//  Created by 장공의 on 20/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

public class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let gradientLayer = layer as? CAGradientLayer else { return }

        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.55).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        ]
    }
}
