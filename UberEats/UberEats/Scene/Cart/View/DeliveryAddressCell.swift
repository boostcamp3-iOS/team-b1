//
//  DeliveryAddressCell.swift
//  UberEats
//
//  Created by 장공의 on 10/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class DeliveryAddressCell: UITableViewCell {

    @IBOutlet weak var locationUIImage: UIImageView!

    @IBOutlet weak var detailedAddressLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var deliveryMethodAndRoomNumberLabel: UILabel!

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

        layer.addBorder([.bottom], color: UIColor.black, width: 0.1)
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
