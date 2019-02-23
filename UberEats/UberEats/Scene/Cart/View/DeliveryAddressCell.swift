//
//  DeliveryAddressCell.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import GoogleMaps

class DeliveryAddressCell: UITableViewCell {

    @IBOutlet weak var locationMapView: GMSMapView!

    @IBOutlet weak var detailedAddressLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var deliveryMethodAndRoomNumberLabel: UILabel!

    private var userLocation = CLLocationCoordinate2D(latitude: 37.49646975398706, longitude: 127.02905088660754)

    var deilveryInfo: DeilveryInfoModel! {
        didSet {
            detailedAddressLabel.text = deilveryInfo.detailedAddress.textWithSpaces
            addressLabel.text = "\(deilveryInfo.address) \(deilveryInfo.detailedAddress)"
            let deilveryMethodText = deilveryInfo.deliveryMethod == .deliveryToDoor ?
                "문 앞까지 배달" : "밖에서 픽업"
            deliveryMethodAndRoomNumberLabel.text = "\(deilveryMethodText), \(deilveryInfo.roomNumber)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMapView()
        layer.addBorder([.bottom], color: UIColor.black, width: 0.1)
    }

    private func setupMapView() {
        let camera = GMSCameraPosition(latitude: userLocation.latitude,
                                       longitude: userLocation.longitude,
                                       zoom: 16)

        locationMapView.camera = camera

        let userMarker = GMSMarker(position: userLocation)
        userMarker.map = locationMapView

        locationMapView.isUserInteractionEnabled = false
    }
}

private extension String {
    var textWithSpaces: String {
        var ret: String = ""
        var target = self

        target.removeAll(where: { " " == $0 })

        for char in target {
            ret += "\(char) "
        }

        return ret
    }
}
