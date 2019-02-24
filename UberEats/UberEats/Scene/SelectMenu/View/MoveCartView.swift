//
//  MoveCartView.swift
//  UberEats
//
//  Created by 이혜주 on 24/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class MoveCartView: UIView {

    lazy var moveCartButton: OrderButton = {
        let button = OrderButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.orderButtonText = "카트보기"
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(moveCartButton)

        NSLayoutConstraint.activate([
            moveCartButton.topAnchor.constraint(equalTo: topAnchor),
            moveCartButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            moveCartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moveCartButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
}
