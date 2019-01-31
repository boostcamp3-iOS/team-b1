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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(recommendLabel)
        recommendLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        recommendLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
