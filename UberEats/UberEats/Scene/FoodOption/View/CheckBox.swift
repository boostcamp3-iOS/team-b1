//
//  CheckBox.swift
//  UberEats
//
//  Created by 이혜주 on 22/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    let checkedImage = UIImage(named: "checked")

    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(nil, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        tintColor = #colorLiteral(red: 0.2365899086, green: 0.5831430554, blue: 0.1253130138, alpha: 1)

        self.addTarget(self, action: #selector(touchUpCheckBox(_:)), for: .touchUpInside)
    }

    @objc private func touchUpCheckBox(_: UIButton) {
        isChecked = !isChecked
    }

}
