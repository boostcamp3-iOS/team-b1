//
//  TitleCustomView.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class TitleCustomView: UIView {
    var titleLabelLeadingConstraint = NSLayoutConstraint()
    var titleLabelTrailingConstraint = NSLayoutConstraint()
    var titleLabelTopConstraint = NSLayoutConstraint()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "버거킹 차병원 사거리 Burger King Cha Hospitaldkfjalsd"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22)
        return label
    }()

    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.text = "버거﹒패스트푸드﹒₩₩₩"
        return label
    }()

    let timeAndGradeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.text = "15-25분 4.5"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        backgroundColor = .white

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(timeAndGradeLabel)

        titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27)
        titleLabelLeadingConstraint.isActive = true

        titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27)
        titleLabelTrailingConstraint.isActive = true

        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25)
        titleLabelTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),

            timeAndGradeLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 15),
            timeAndGradeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            timeAndGradeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
            ])
    }
}
