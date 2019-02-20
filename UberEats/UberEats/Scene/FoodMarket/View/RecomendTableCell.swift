//
//  TableViewCell.swift
//  uberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class RecomendTableCell: UITableViewCell {

    private let RecommendCollectionViewCellNIB = UINib(nibName: "RecommendCollectionViewCell", bundle: nil)

    public let collectionVIewCellId = "RecommendCollectionViewCellId"
    public let colelctionVIewMoreRestCellId = "colelctionVIewMoreRestCellId"

    public lazy var collectionView: UICollectionView = {
        let layout = ItemCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        let collectionVIew = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionVIew.tag = 1
        collectionVIew.register(RecommendCollectionViewCellNIB, forCellWithReuseIdentifier: collectionVIewCellId)
        collectionVIew.register(RestaurtSeeMoreCollectionViewCell.self, forCellWithReuseIdentifier: colelctionVIewMoreRestCellId)
        collectionVIew.translatesAutoresizingMaskIntoConstraints = false
        return collectionVIew
    }()

    public let recommendLabel: UILabel = {
        let label = UILabel()
        label.text = "추천 요리"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(recommendLabel)
        addSubview(collectionView)

        recommendLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        recommendLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        recommendLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        recommendLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        NSLayoutConstraint.activate(
            [
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: recommendLabel.bottomAnchor)
            ]
        )

        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)

        selectionStyle = .none
        collectionView.showsHorizontalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
