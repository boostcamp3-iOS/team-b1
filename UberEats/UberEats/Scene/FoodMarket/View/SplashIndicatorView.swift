//
//  SplashIndicatorView.swift
//  UberEats
//
//  Created by 이혜주 on 19/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class SplashIndicatorView: UIView {

    let indicatorSlider: IndicatorSlider = {
        let slider = IndicatorSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.thumbTintColor = .clear
        slider.tintColor = .white
        slider.value = 0
        slider.maximumTrackTintColor = .clear
        return slider
    }()

    let uberEatsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash812"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        Timer.scheduledTimer(timeInterval: 0,
                             target: self,
                             selector: #selector(setupIndicatorAnimation(_:)),
                             userInfo: nil,
                             repeats: false)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(uberEatsImageView)
        uberEatsImageView.addSubview(indicatorSlider)

        NSLayoutConstraint.activate([
            uberEatsImageView.topAnchor.constraint(equalTo: topAnchor),
            uberEatsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uberEatsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uberEatsImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            indicatorSlider.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            indicatorSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorSlider.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorSlider.heightAnchor.constraint(equalToConstant: 10)
            ])
    }

    @objc private func setupIndicatorAnimation(_: Timer) {
        indicatorSlider.value = 1
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .repeat,
                       animations: {
                            self.layoutIfNeeded()
                        }, completion: nil)
    }
}

class IndicatorSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin,
                                  size: CGSize(width: bounds.size.width,
                                               height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

}
