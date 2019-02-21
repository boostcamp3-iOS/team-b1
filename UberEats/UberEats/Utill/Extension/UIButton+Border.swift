//
//  UIButtonBorder.swift
//  UberEats
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/26961274/how-can-i-make-a-button-have-a-rounded-border-in-swift
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
