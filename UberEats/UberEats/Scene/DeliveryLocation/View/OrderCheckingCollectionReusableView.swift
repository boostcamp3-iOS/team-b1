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
    @IBOutlet weak var currentProgressSlider: UISlider!
    @IBOutlet weak var animationSlider: UISlider!
    @IBOutlet weak var currentProgressLabel: UILabel!

    var sliderTimer = Timer()

    var delegate: ChangeScrollDelegate?

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

    override func awakeFromNib() {
        super.awakeFromNib()
        setSliderAnimation()
    }

    private func setSliderAnimation() {
        currentProgressSlider.value = 3
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                           target: self,
                                           selector: #selector(actionAnimation(_:)),
                                           userInfo: nil,
                                           repeats: false)
    }

    @objc private func actionAnimation(_: Timer) {
        animationSlider.value = 3
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.scrollToTop()
    }
}
