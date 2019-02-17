//
//  OrderButtonView.swift
//  UberEats
//
//  Created by 장공의 on 12/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderButton: UIView {

    private let xibName = "OrderButton"

    var orderButtonClickable: OrderButtonClickable?

    @IBOutlet var orderButtonVIew: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }

    @IBAction func clickedOrderButton(_ sender: Any) {
        orderButtonClickable?.onClickedOrderButton(sender)
    }

    private func initNib() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        orderButtonVIew.fixInView(self)
    }
}

protocol OrderButtonClickable {
    func onClickedOrderButton(_ sender: Any)
}
