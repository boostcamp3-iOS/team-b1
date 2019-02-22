//
//  NewRestCollectionViewCell.swift
//  uberEats
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common

class RestaurtSeeMoreCollectionViewCell: UICollectionViewCell {

    public let discountImageView = UIImageView().initImageView("rightArrow")

    public let discountLabel: UILabel = {
        let label = UILabel()
        label.text = "더보기"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(discountImageView)
        addSubview(discountLabel)

        NSLayoutConstraint.activate([
            discountImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            discountImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            discountImageView.heightAnchor.constraint(equalToConstant: 50),
            discountImageView.widthAnchor.constraint(equalToConstant: 50),

            discountLabel.topAnchor.constraint(equalTo: discountImageView.bottomAnchor, constant: 15),
            discountLabel.centerXAnchor.constraint(equalTo: centerXAnchor)

            ])

        discountImageView.layer.cornerRadius = 25
        discountImageView.layer.masksToBounds = true

        discountImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
