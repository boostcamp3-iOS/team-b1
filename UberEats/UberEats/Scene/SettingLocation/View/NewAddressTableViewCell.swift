//
//  NewAddressTableViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class NewAddressTableViewCell: UITableViewCell {

    private let markerImageView = UIImageView().initImageView("icLocation")

    let newAddressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "새 주소 입력"
        textField.clearButtonMode = .always
        textField.tintColor = #colorLiteral(red: 0.368627451, green: 0.6274509804, blue: 0.2274509804, alpha: 1)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        selectionStyle = .none

        addSubview(markerImageView)
        addSubview(newAddressTextField)

        NSLayoutConstraint.activate([
            markerImageView.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: ConstraintOfSettingLocation.paddingAtSettingLocation),
            markerImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: -ConstraintOfSettingLocation.paddingAtSettingLocation),
            markerImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: ConstraintOfSettingLocation.paddingAtSettingLocation),
            markerImageView.widthAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),
            markerImageView.heightAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),

            newAddressTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            newAddressTextField.leadingAnchor.constraint(equalTo: markerImageView.trailingAnchor,
                                                         constant: ConstraintOfSettingLocation.leadingOfLabelAndTextField),
            newAddressTextField.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                          constant: -ConstraintOfSettingLocation.paddingAtSettingLocation)
            ])
    }
}
