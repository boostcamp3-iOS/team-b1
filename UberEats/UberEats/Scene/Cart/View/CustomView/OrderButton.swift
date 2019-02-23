//
//  OrderButtonView.swift
//  UberEats
//
//  Created by 장공의 on 12/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderButton: UIView {

    private static let xibName = "OrderButton"
    private static let orderButtonDefaultText = "카트에 1 추가"

    var orderButtonClickable: OrderButtonClickable?

    @IBOutlet var orderButtonView: UIView!

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var orderButton: UIButton!

    var orderInfos: [OrderInfoModel] = [OrderInfoModel]() {
        didSet {
            let amount = orderInfos.map({ $0.price })
            .reduce(0) { $0 + $1 }
            amountLabel.text = "￦\(amount.formattedWithSeparator)"
        }
    }

    var orderButtonText: String? {
        get {
            return orderButton?.currentTitle
        }
        set {
            orderButton?.setTitle(newValue, for: .normal)
        }
    }

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

    func setAmount(quantity: Int, price: Int) {
        amountLabel.text = "￦\(quantity * price)"
    }

    private func initNib() {
        Bundle.main.loadNibNamed(OrderButton.xibName, owner: self, options: nil)
        orderButtonView.fixInView(self)
        orderButtonText = OrderButton.orderButtonDefaultText
    }

}

protocol OrderButtonClickable {
    func onClickedOrderButton(_ sender: Any)
}
