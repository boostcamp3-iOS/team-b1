//
//  CurrentLocationTableViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    private static let addressAndOptionLabelFontSize: CGFloat = 15

    let selectStatusImageView = UIImageView().initImageView("icCheck")

    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel().setupWithFontSize(addressAndOptionLabelFontSize)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        return label
    }()

    let deliveryOptionLabel: UILabel = {
        let label = UILabel().setupWithFontSize(addressAndOptionLabelFontSize)
        label.textColor = .gray
        return label
    }()

    let currentLocationInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()

    var locationInfo: LocationCellModel? {
        didSet {
            guard let locationInfo = locationInfo else {
                return
            }

            leftImageView.image = UIImage(named: locationInfo.imageName)
            titleLabel.text = locationInfo.title
            addressLabel.text = locationInfo.address
            deliveryOptionLabel.text = locationInfo.option
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        selectStatusImageView.isHidden = true
        selectionStyle = .none

        currentLocationInfoStackView.addArrangedSubview(titleLabel)
        currentLocationInfoStackView.addArrangedSubview(addressLabel)
        currentLocationInfoStackView.addArrangedSubview(deliveryOptionLabel)

        addSubview(leftImageView)
        addSubview(currentLocationInfoStackView)
        addSubview(selectStatusImageView)

        NSLayoutConstraint.activate([
            leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: ConstraintOfSettingLocation.paddingAtSettingLocation),
            leftImageView.widthAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),
            leftImageView.heightAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),

            currentLocationInfoStackView.topAnchor.constraint(equalTo: topAnchor,
                                                              constant: ConstraintOfSettingLocation.paddingAtSettingLocation),
            currentLocationInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                 constant: -ConstraintOfSettingLocation.paddingAtSettingLocation),
            currentLocationInfoStackView.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor,
                                                                  constant: ConstraintOfSettingLocation.leadingOfLabelAndTextField),
            currentLocationInfoStackView.trailingAnchor.constraint(lessThanOrEqualTo: selectStatusImageView.leadingAnchor,
                                                                   constant: -ConstraintOfSettingLocation.trailingOfMainLabel),

            selectStatusImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectStatusImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                            constant: -ConstraintOfSettingLocation.trailingOfselectStatus)
            ])
    }

}
