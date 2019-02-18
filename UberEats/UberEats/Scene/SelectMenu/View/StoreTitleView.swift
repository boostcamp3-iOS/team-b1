//
//  TitleCustomView.swift
//  OberEatsPractice
//
//  Created by 이혜주 on 22/01/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import Common

class StoreTitleView: UIView {
    struct Metrix {
        static let headerHeight: CGFloat = 283
        static let titleTopMargin: CGFloat = 171
        static let scrollLimit: CGFloat = titleTopMargin
        static let titleLabelTopMargin: CGFloat = 25
        static let buttonSize: CGFloat = 25
        static let titleLabelLeadingMargin: CGFloat = 27
    }

    var titleLabelLeadingConstraint = NSLayoutConstraint()
    var titleLabelTrailingConstraint = NSLayoutConstraint()
    var titleLabelTopConstraint = NSLayoutConstraint()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "버거킹 차병원 사거리 Burger King Cha Hospitaldkfjalsd"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22)
        return label
    }()

    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
//        label.text = "버거﹒패스트푸드﹒₩₩₩"
        return label
    }()

    let timeAndGradeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
//        label.text = "15-25분 4.5"
        return label
    }()

    private weak var parentView: UIView!

    private var storeViewTopConstraint = NSLayoutConstraint()
    private var storeViewWidthConstraint = NSLayoutConstraint()
    private var storeViewHeightConstraint = NSLayoutConstraint()

    var store: Store? {
        didSet {
            guard let store = store else {
                return
            }

            titleLabel.text = store.name
            detailLabel.text = store.category
            timeAndGradeLabel.text = store.deliveryTime
        }
    }

    convenience init(parentView: UIView) {
        self.init(frame: CGRect.zero)

        self.parentView = parentView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
    }

    func setupLayout() {
        backgroundColor = .white
        layer.zPosition = .greatestFiniteMagnitude

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

    public func setupConstraint() {
        storeViewTopConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: parentView,
                                                    attribute: .top,
                                                    multiplier: 1,
                                                    constant: Metrix.titleTopMargin)
        storeViewTopConstraint.isActive = true

        storeViewWidthConstraint = NSLayoutConstraint(item: self,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: parentView,
                                                      attribute: .width,
                                                      multiplier: 0.9,
                                                      constant: 0)
        storeViewWidthConstraint.isActive = true

        storeViewHeightConstraint = NSLayoutConstraint(item: self,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .width,
                                                       multiplier: 0.5,
                                                       constant: 0)
        storeViewHeightConstraint.isActive = true
    }

    public func changedContentOffset(currentScroll: CGFloat, headerHeight: CGFloat) {
        //        let diff: CGFloat = headerHeight - currentScroll

        titleLabel.numberOfLines = currentScroll > (Metrix.scrollLimit - 10) ? 1 : 2

        storeViewTopConstraint.constant = Metrix.titleTopMargin - currentScroll

        if currentScroll < Metrix.scrollLimit && currentScroll > 0 {
            storeViewWidthConstraint.constant = currentScroll * 0.2
            storeViewHeightConstraint.constant = -(currentScroll * 0.2)
            titleLabelTopConstraint.constant = (currentScroll * 0.2) + Metrix.titleLabelTopMargin
            detailLabel.alpha = 1 - currentScroll / Metrix.scrollLimit
            timeAndGradeLabel.alpha = 0.8 - currentScroll / Metrix.scrollLimit

            titleLabelLeadingConstraint.constant = currentScroll * 0.1 + Metrix.titleLabelLeadingMargin
            titleLabelTrailingConstraint.constant = -(currentScroll * 0.1 + Metrix.titleLabelLeadingMargin)

        } else if currentScroll > Metrix.scrollLimit {
            storeViewTopConstraint.constant = 0
            storeViewWidthConstraint.constant = parentView.frame.width * 0.1
            storeViewHeightConstraint.constant = -38
            titleLabelTopConstraint.constant = Metrix.titleLabelTopMargin * 2.3

            titleLabelLeadingConstraint.constant = Metrix.buttonSize + 20
            titleLabelTrailingConstraint.constant = -(Metrix.buttonSize + 20)
        }
    }
}
