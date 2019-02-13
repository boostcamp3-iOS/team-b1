//
//  userLocationView.swift
//  UberEats
//
//  Created by 이혜주 on 13/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class UserLocationView: UIView {

    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "메리츠타워"
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(backView)
        backView.addSubview(locationLabel)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            locationLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor)
            ])
    }

}
