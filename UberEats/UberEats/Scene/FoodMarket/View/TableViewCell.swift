//
//  TableViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!

    public let recommendLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
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

        self.addSubview(recommendLabel)

        recommendLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        recommendLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
