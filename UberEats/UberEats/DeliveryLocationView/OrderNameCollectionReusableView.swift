//
//  OrderNameCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderNameCollectionReusableView: UICollectionReusableView {
    
    let orderNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "#46F45 주문"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLayout() {
        backgroundColor = .white
        addSubview(orderNameLabel)
        
        NSLayoutConstraint.activate([
            orderNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            orderNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
            ])
    }
}
