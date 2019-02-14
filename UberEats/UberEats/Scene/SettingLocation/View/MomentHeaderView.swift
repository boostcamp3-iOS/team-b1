//
//  MomentHeaderView.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class MomentHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시기"
        label.textColor = .gray
        return label
    }()

    private func setupLayout() {
        backgroundColor = .white

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstraintOfSettingLocation.paddingAtSettingLocation)
            ])

    }

}
