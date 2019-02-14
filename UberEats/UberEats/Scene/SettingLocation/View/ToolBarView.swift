//
//  ToolBarView.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class ToolBarView: UIView {

    var delegate: CloseDelegate?

    let closeButton: UIButton = UIButton().initButtonWithImage("btnClose")

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배달 세부 사항"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        addSubview(closeButton)
        addSubview(titleLabel)

        closeButton.addTarget(self, action: #selector(touchUpCloseButton(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
    }

    @objc private func touchUpCloseButton(_: UIButton) {
        delegate?.dismissModal()
    }
}
