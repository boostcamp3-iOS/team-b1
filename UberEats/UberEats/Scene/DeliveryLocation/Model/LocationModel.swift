//
//  LocationModel.swift
//  UberEats
//
//  Created by 이혜주 on 08/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import CoreLocation

enum SectionName: Int {
    case deliveryManInfo = 0
    case timeDetail
    case orders
    case sale
}

struct DelivererInfo {
    let name: String
    let rate: Int
    let image: UIImage?
    let vehicle: String
    let phoneNumber: String
    let email: String
}

enum Distance: Double {
    case lessThanOneKM = 0
    case oneKM
    case twoKM
    case threeKM

    var range: Range<Int> {
        switch self {
        case .lessThanOneKM : return 0 ..< 1000
        case .oneKM : return 1000 ..< 2000
        case .twoKM : return 2000 ..< 3000
        case .threeKM : return 3000 ..< 4000
        }
    }
}

func getButtonTopConstraint(_ height: CGFloat) -> CGFloat {
    switch height {
    case 960, 1136, 1334, 1920, 2208:
        return 25
    case 1792, 2436, 2688:
        return 45
    default:
        return 0
    }
}

func getZoomValue(userLocation2D: CLLocationCoordinate2D,
                  storeLocation2D: CLLocationCoordinate2D) -> Float {
    let userLocation = CLLocation(latitude: userLocation2D.latitude,
                                  longitude: userLocation2D.longitude)
    let storeLocation = CLLocation(latitude: storeLocation2D.latitude,
                                   longitude: storeLocation2D.longitude)

    let distance = userLocation.distance(from: storeLocation)

    if distance > 3000 {
        return 13
    } else if distance > 2000 {
        return 14
    } else if distance > 1000 {
        return 15
    } else {
        return 16
    }
}
