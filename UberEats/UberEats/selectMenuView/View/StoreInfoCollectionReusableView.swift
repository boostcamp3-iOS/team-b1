//
//  StoreInfoCollectionReusableView.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 23/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class StoreInfoCollectionReusableView: UICollectionReusableView {

    lazy var titleView: TitleCustomView = {
        let view = TitleCustomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.zPosition = .greatestFiniteMagnitude
        view.layer.cornerRadius = 5

        //shadow
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        //        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    func setupLayout() {
        addSubview(titleView)

        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
