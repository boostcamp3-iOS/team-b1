//
//  OrderCheckingCollectionReusableView.swift
//  UberEats
//
//  Created by 이혜주 on 04/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class OrderCheckingCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeTitleLabel: UILabel!
    @IBOutlet weak var currentProgressLabel: UILabel!
    @IBOutlet weak var orderProgressBar: UIProgressView!
    @IBOutlet weak var orderProgressTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundProgressBar: UIProgressView!

    var sliderTimer = Timer()

    weak var delegate: ChangeScrollDelegate?

    var titleName: String? {
        didSet {
            guard let titleName = titleName else {
                return
            }

            storeNameLabel.text = titleName
        }
    }

    var arrivalTime: String? {
        didSet {
            guard let arrivalTime = arrivalTime else {
                return
            }

            arrivalTimeLabel.text = arrivalTime
        }
    }

    var progressStatus: ProgressStatus? {
        didSet {
            guard let status = progressStatus else {
                return
            }

            switch status {
            case .verifyingOrder:
                currentProgressLabel.text = "주문 확인중"
            case .preparingFood:
                currentProgressLabel.text = "음식 준비중"
            case .delivering:
                currentProgressLabel.text = "음식을 배달중입니다."
            }
            setSliderAnimation()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func setSliderAnimation() {
        self.orderProgressBar.setProgress(1, animated: true)
        UIView.animate(withDuration: 30) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.scrollToTop()
    }
}

enum ProgressStatus: Int {
    case verifyingOrder = 0
    case preparingFood
    case delivering
}
