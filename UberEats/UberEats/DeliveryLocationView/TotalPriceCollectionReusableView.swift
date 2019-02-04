//
//  TotalPriceCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class TotalPriceCollectionReusableView: UICollectionReusableView {
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "합계: ₩12,200"
        return label
    }()
    
    let billButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = "영수증 보기"
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.textColor = .gray
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9098526835, green: 0.9044440985, blue: 0.9140102863, alpha: 1)
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
        backgroundColor = .white
        
        addSubview(totalPriceLabel)
        addSubview(billButton)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            totalPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            totalPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            
            billButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            billButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 10)
            ])
    }
}
