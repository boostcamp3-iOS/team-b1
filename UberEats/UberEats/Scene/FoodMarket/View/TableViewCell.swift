//
//  TableViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var collectionView: UICollectionView!

    public let recommendLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setLabel(_ section: Int) {
        let section = Section(rawValue: section)!
        switch section {
        case .recommendFood:
            recommendLabel.text = "추천 요리"
        case .nearestRest:
            recommendLabel.text = "가까운 인기 레스토랑"
        case .expectedTime:
            recommendLabel.text = "예상 시간 30분 이하"
        case .newRest:
            recommendLabel.text = "새로운 레스토랑"
        default:
            recommendLabel.text = ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(recommendLabel)

        NSLayoutConstraint.activate(
            [
                recommendLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                recommendLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
                recommendLabel.widthAnchor.constraint(equalToConstant: 200),
                recommendLabel.heightAnchor.constraint(equalToConstant: 30),

                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: recommendLabel.bottomAnchor)
            ]
        )

        selectionStyle = .none
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)

    }
}
