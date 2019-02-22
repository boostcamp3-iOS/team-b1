//
//  QuantityControlVIew.swift
//  UberEats
//
//  Created by 장공의 on 21/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class QuantityControlView: UIView {

    private let xibName = "QuantityControlView"

    @IBOutlet var quantityControlContantVIew: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }

    private func initNib() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        quantityControlContantVIew.fixInView(self)
    }

}
