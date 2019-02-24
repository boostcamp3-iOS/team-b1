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

    private var storeTitleView = UIView()

    private var titleLabelLeadingConstraint = NSLayoutConstraint()
    private var titleLabelTrailingConstraint = NSLayoutConstraint()
    private var titleLabelTopConstraint = NSLayoutConstraint()
    private var storeViewTopConstraint = NSLayoutConstraint()
    private var storeViewWidthConstraint = NSLayoutConstraint()
    private var storeViewHeightConstraint = NSLayoutConstraint()

    let titleLabel: UILabel = {
        let label = UILabel().setupWithFontSize(LabelFontSize.titleLabel)
        label.numberOfLines = 2
        return label
    }()

    let detailLabel = UILabel().setupWithFontSize(LabelFontSize.detailLabelAndTimeGradeLabel)

    let timeAndGradeLabel = UILabel().setupWithFontSize(LabelFontSize.detailLabelAndTimeGradeLabel)

    let clockImageView = UIImageView().initImageView("icClock")

    var store: StoreForView? {
        didSet {
            guard let store = store else {
                return
            }

            titleLabel.text = store.name
            detailLabel.text = store.category
            timeAndGradeLabel.text = store.deliveryTime + "분"
            if store.rate.score != 0 {
                timeAndGradeLabel.text?.append(" " + String(store.rate.score) + " ★ ("
                                                + String(store.rate.numberOfRater) + ")")
            }

        }
    }

    convenience init(_ storeTitleView: UIView) {
        self.init(frame: CGRect.zero)

        self.storeTitleView = storeTitleView
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

        layer.zPosition = .greatestFiniteMagnitude
        layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
    }

    func setupLayout() {

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(timeAndGradeLabel)
        addSubview(clockImageView)

        titleLabelLeadingConstraint = titleLabel.leadingAnchor
                                                .constraint(equalTo: self.leadingAnchor,
                                                            constant: Metrix.titleLabelLeadingAndTrailingMargin)
        titleLabelLeadingConstraint.isActive = true

        titleLabelTrailingConstraint = titleLabel.trailingAnchor
                                                 .constraint(equalTo: self.trailingAnchor,
                                                             constant: -Metrix.titleLabelLeadingAndTrailingMargin)
        titleLabelTrailingConstraint.isActive = true

        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                                  constant: Metrix.titleLabelTopMargin)
        titleLabelTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor,
                                             constant: Metrix.labelTopMargin),
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: Metrix.labelLeadingAndTrailingMargin),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -Metrix.labelLeadingAndTrailingMargin),

            clockImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrix.labelLeadingAndTrailingMargin),
            clockImageView.centerYAnchor.constraint(equalTo: timeAndGradeLabel.centerYAnchor),
            clockImageView.widthAnchor.constraint(equalToConstant: 15),
            clockImageView.heightAnchor.constraint(equalToConstant: 15),

            timeAndGradeLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor,
                                                   constant: Metrix.labelTopMargin),
            timeAndGradeLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor,
                                                       constant: 3),
            timeAndGradeLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                        constant: -Metrix.labelLeadingAndTrailingMargin),
            timeAndGradeLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                      constant: -Metrix.timeAndGradeLabelBottomMargin)
            ])
    }

    public func setupConstraint() {
        storeViewTopConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: storeTitleView,
                                                    attribute: .top,
                                                    multiplier: 1,
                                                    constant: Metrix.titleTopMargin)
        storeViewTopConstraint.isActive = true

        storeViewWidthConstraint = NSLayoutConstraint(item: self,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: storeTitleView,
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

        titleLabel.numberOfLines = currentScroll > (Metrix.scrollLimit - 10) ? 1 : 2

        storeViewTopConstraint.constant = Metrix.titleTopMargin - currentScroll

        if currentScroll < 0 {

            storeViewWidthConstraint.constant = 0
            storeViewHeightConstraint.constant = 0

            titleLabelTopConstraint.constant = Metrix.titleLabelTopMargin
            titleLabelLeadingConstraint.constant = Metrix.titleLabelLeadingAndTrailingMargin
            titleLabelTrailingConstraint.constant = -Metrix.titleLabelLeadingAndTrailingMargin

        } else if currentScroll < Metrix.scrollLimit && currentScroll > 0 {

            storeViewWidthConstraint.constant = currentScroll * 0.2
            storeViewHeightConstraint.constant = -(currentScroll * 0.2)

            titleLabelTopConstraint.constant = (currentScroll * 0.2)
                                                    + Metrix.titleLabelTopMargin
            titleLabelLeadingConstraint.constant = currentScroll * 0.1
                                                        + Metrix.titleLabelLeadingAndTrailingMargin
            titleLabelTrailingConstraint.constant = -(currentScroll * 0.1
                                                        + Metrix.titleLabelLeadingAndTrailingMargin)

            detailLabel.alpha = AnimationValueOfStoreInfoView.basicAlpha
                                    - currentScroll / Metrix.scrollLimit
            timeAndGradeLabel.alpha = AnimationValueOfStoreInfoView.basicAlpha - currentScroll / Metrix.scrollLimit
            clockImageView.alpha = AnimationValueOfStoreInfoView.basicAlpha - currentScroll / Metrix.scrollLimit

        } else if currentScroll > Metrix.scrollLimit {

            storeViewTopConstraint.constant = 0
            storeViewWidthConstraint.constant = storeTitleView.frame.width
                                                    * AnimationValueOfStoreInfoView.widthConstantRatioAfterSticky
            storeViewHeightConstraint.constant = AnimationValueOfStoreInfoView.heightConstantAfterSticky

            titleLabelTopConstraint.constant = Metrix.titleLabelTopMargin * AnimationValueOfStoreInfoView.titleTopConstantRatioAfterSticky
            titleLabelLeadingConstraint.constant = buttonSize + 20
            titleLabelTrailingConstraint.constant = -(buttonSize + 20)

        }
    }
}

private struct AnimationValueOfStoreInfoView {
    static let basicAlpha: CGFloat = 1

    static let heightConstantAfterSticky: CGFloat = -38
    static let widthConstantRatioAfterSticky: CGFloat = 0.1
    static let titleTopConstantRatioAfterSticky: CGFloat = 2.3
}

private struct Metrix {
    static let headerHeight: CGFloat = 283
    static let scrollLimit: CGFloat = titleTopMargin
    static let titleTopMargin: CGFloat = 171
    static let titleLabelTopMargin: CGFloat = 25
    static let titleLabelLeadingAndTrailingMargin: CGFloat = 27
    static let labelTopMargin: CGFloat = 15
    static let labelLeadingAndTrailingMargin: CGFloat = 25
    static let timeAndGradeLabelBottomMargin: CGFloat = 25
}

private struct LabelFontSize {
    static let titleLabel: CGFloat = 22
    static let detailLabelAndTimeGradeLabel: CGFloat = 15
}
