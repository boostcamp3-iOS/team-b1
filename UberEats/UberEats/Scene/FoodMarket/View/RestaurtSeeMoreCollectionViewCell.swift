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

    public let discountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rightArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

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

        discountImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        discountImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        discountImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        discountImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        discountLabel.topAnchor.constraint(equalTo: discountImageView.bottomAnchor, constant: 15).isActive = true
        discountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        discountImageView.layer.cornerRadius = 25
        discountImageView.layer.masksToBounds = true

        discountImageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
