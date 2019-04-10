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
    @IBOutlet weak var deliveryProgressSlider: UISlider!

    var sliderTimer = Timer()

    weak var changeScrollDelegate: ChangeScrollDelegate?
    weak var deliveryCompleteDelegate: DeliveryCompleteDelegate?

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
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setSliderAnimation()
    }

    private func setSliderAnimation() {
        Timer.scheduledTimer(timeInterval: 0,
                             target: self,
                             selector: #selector(setupSliderAnimation(_:)),
                             userInfo: nil,
                             repeats: false)
    }

    @objc private func setupSliderAnimation(_: Timer) {
        deliveryProgressSlider.value = 10

        UIView.animate(withDuration: 60,
                       animations: { [weak self] in
                        self?.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.deliveryCompleteDelegate?.moveToFoodMarket()
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeScrollDelegate?.scrollToTop()
    }

    func configure(storeName: String,
                   time: String,
                   status: ProgressStatus,
                   locationViewController: LocationViewController) {
        storeNameLabel.text = storeName
        arrivalTimeLabel.text = time
        progressStatus = status
        changeScrollDelegate = locationViewController
        deliveryCompleteDelegate = locationViewController
    }
}

enum ProgressStatus: Int {
    case verifyingOrder = 0
    case preparingFood
    case delivering
}
