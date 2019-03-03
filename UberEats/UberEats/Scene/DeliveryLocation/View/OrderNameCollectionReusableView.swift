//
//  OrderNameCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderNameCollectionReusableView: UICollectionReusableView {

    let orderNameLabel: UILabel = {
        let label = UILabel().setupWithFontSize(NumberForLabel.orderNameLabelFontSize)
        label.text = "#46F45 주문"
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupLayout() {
        backgroundColor = .white
        addSubview(orderNameLabel)

        NSLayoutConstraint.activate([
            orderNameLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor,
                            constant: NumberForLabel.orderNameLabelLeadingMargin),
            orderNameLabel.bottomAnchor
                .constraint(equalTo: bottomAnchor,
                            constant: NumberForLabel.orderNameLabelBottomMargin)
            ])
    }
}

private struct NumberForLabel {
    static let orderNameLabelFontSize: CGFloat = 14
    static let orderNameLabelLeadingMargin: CGFloat = 20
    static let orderNameLabelBottomMargin: CGFloat = -15
}
