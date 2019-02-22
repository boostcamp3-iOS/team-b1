//
//  MomentTableViewCell.swift
//  UberEats
//
//  Created by 이혜주 on 14/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {

    private let selectStatusImageView = UIImageView().initImageView("icCheck")

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

    var moment: MomentCellModel? {
        didSet {
            guard let moment = moment else {
                return
            }

            leftImageView.image = UIImage(named: moment.imageName)
            titleLabel.text = moment.title

            if titleLabel.text == "주문 예약" {
                selectStatusImageView.isHidden = true
            }
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
        selectionStyle = .none

        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(selectStatusImageView)

        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: ConstraintOfSettingLocation.paddingAtSettingLocation),
            leftImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -ConstraintOfSettingLocation.paddingAtSettingLocation),
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: ConstraintOfSettingLocation.paddingAtSettingLocation),
            leftImageView.widthAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),
            leftImageView.heightAnchor.constraint(equalToConstant: ConstraintOfSettingLocation.buttonSizeAtSettingLocation),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor,
                                                constant: ConstraintOfSettingLocation.leadingOfLabelAndTextField),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: selectStatusImageView.leadingAnchor,
                                                 constant: -ConstraintOfSettingLocation.trailingOfMainLabel),

            selectStatusImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectStatusImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                            constant: -ConstraintOfSettingLocation.trailingOfselectStatus)
            ])
    }

}
