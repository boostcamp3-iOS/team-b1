//
//  orderCancelCollectionViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderCancelCollectionViewCell: UICollectionViewCell {

    private static let cancelLabelFontSize: CGFloat = 15

    let cancelLabel: UILabel = {
        let label = UILabel().setupWithFontSize(OrderCancelCollectionViewCell.cancelLabelFontSize)
        label.text = "주문 취소"
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

    private func setupLayout() {
        backgroundColor = .white

        addSubview(cancelLabel)

        NSLayoutConstraint.activate([
            cancelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    func configure(status: Bool) {
        cancelLabel.text = "연락처"
        isHidden = status
    }
}
