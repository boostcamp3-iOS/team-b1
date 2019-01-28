//
//  HeaderView.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
<<<<<<< Updated upstream
    var titleViewWidthConstraint = NSLayoutConstraint()
    var titleViewHeightConstraint = NSLayoutConstraint()

    let titleView: TitleCustomView = {
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

=======
//    var titleViewWidthConstraint = NSLayoutConstraint()
//    var titleViewHeightConstraint = NSLayoutConstraint()
    
>>>>>>> Stashed changes
    lazy var gradientView: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        return gradient
    }()

    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "image"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    func setupLayout() {
        addSubview(imageView)
//        addSubview(titleView)
        imageView.layer.addSublayer(gradientView)
<<<<<<< Updated upstream

        titleViewWidthConstraint = NSLayoutConstraint(item: titleView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -50)
        titleViewWidthConstraint.isActive = true

        titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.6, constant: 0)
        titleViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            titleView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),

=======
//
//        titleViewWidthConstraint = NSLayoutConstraint(item: titleView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -50)
//        titleViewWidthConstraint.isActive = true
//
//        titleViewHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.6, constant: 0)
//        titleViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
//            titleView.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
//            titleView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
//            
>>>>>>> Stashed changes
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
