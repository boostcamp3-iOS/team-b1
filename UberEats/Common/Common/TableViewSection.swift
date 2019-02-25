//
//  SectionEnum.swift
//  UberEats
//
//  Created by admin on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit

public enum TableViewSection: Int, CaseIterable {
    case bannerScroll = 0
    case recommendFood = 1
    case nearestRest = 2
    case expectedTime = 3
    case newRest = 4
    case discount = 5
    case moreRest = 6
    case searchAndSee = 7

    public var numberOfCollectionViewSection: Int {
        switch self {
        case .bannerScroll:
            return 0
        case .recommendFood:
            return 1
        case .nearestRest, .expectedTime, .newRest:
            return 2
        case .discount, .moreRest, .searchAndSee:
            return 0
        }
    }

    public var moreRestCellId: String {
        switch self {
        case .recommendFood, .nearestRest, .newRest, .expectedTime:
            return "colelctionVIewMoreRestCellId"
        default:
            return ""
        }
    }

    public var identifier: String {
        switch self {
        case .moreRest:
            return "SeeMoreRestTableViewCellId"
        case .recommendFood:
            return "RecommendCollectionViewCellId"
        case .nearestRest:
            return "NearestCollectionViewCellId"
        case .newRest:
            return "NewRestCollectionViewCellId"
        case .expectedTime:
            return "ExpectTimeCollectionViewCellId"
        default:
            return ""
        }
    }

    public var nibName: String {
        switch self {
        case .moreRest:
            return "SeeMoreRestTableViewCell"
        case .recommendFood:
            return "RecommendCollectionViewCell"
        case .nearestRest:
            return "NearestCollectionViewCell"
        case .newRest:
            return "NewRestCollectionViewCell"
        case .expectedTime:
            return "ExpectTimeCollectionViewCell"
        default:
            return ""
        }
    }

    public var numberOfSection: Int {
        switch self {
        case .recommendFood, .nearestRest, .expectedTime, .newRest, .discount, .searchAndSee:
            return 1
        case .bannerScroll:
            return 0
        default:
            return 2
        }
    }

    public func heightOfTableViewCell() -> CGFloat {
        switch self {
        case .recommendFood, .nearestRest, .expectedTime, .newRest, .moreRest:
            return heightByDevice(section: self)
        case .discount:
            return 78
        case .searchAndSee:
            return 60
        case .bannerScroll:
            return 200
        }
    }

    public func heightByDevice(section: TableViewSection) -> CGFloat {
        switch self {
        case .recommendFood, .newRest, .expectedTime, .nearestRest :
            return 343
        case .moreRest:
            return 267
        default:
            return 400
        }
    }

    public var getEdgeInset: UIEdgeInsets {
        switch self {
        case .bannerScroll:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .recommendFood:
            return UIEdgeInsets(top: 0, left: UIScreen.main.nativeBounds.width * 0.03, bottom: 0, right: UIScreen.main.nativeBounds.width * 0.03)
        case .nearestRest:
            return UIEdgeInsets(top: 0, left: UIScreen.main.nativeBounds.width * 0.03, bottom: 0, right: UIScreen.main.nativeBounds.width * 0.03)
        case .expectedTime:
            return UIEdgeInsets(top: 0, left: UIScreen.main.nativeBounds.width * 0.03, bottom: 0, right: UIScreen.main.nativeBounds.width * 0.03)
        case .newRest:
            return UIEdgeInsets(top: 0, left: UIScreen.main.nativeBounds.width * 0.03, bottom: 0, right: UIScreen.main.nativeBounds.width * 0.03)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

public extension UIDevice {
    var pageControlX: CGFloat {
        switch UIScreen.main.nativeBounds.height {
        case 960://iPhones_4_4S
            return 40
        case 1136://iPhones_5_5s_5c_SE
            return 40
        case 1334://iPhones_6_6s_7_8
            return 3
        case 1792://iPhone_XR
            return 5
        case 1920, 2208://iPhones_6Plus_6sPlus_7Plus_8Plus
            return 5
        case 2436://iPhones_X_XS
            return 0
        case 2688://iPhone_XSMax
            return 5
        default://unknown
            return 5
        }
    }

    var keyboardAppearBottomEdgeInset: CGFloat {
        switch UIScreen.main.nativeBounds.height {
        case 960://iPhones_4_4S
            return 40
        case 1136://iPhones_5_5s_5c_SE
            return 40
        case 1334://iPhones_6_6s_7_8
            return 272
        case 1792://iPhone_XR
            return 5
        case 1920, 2208://iPhones_6Plus_6sPlus_7Plus_8Plus
            return 5
        case 2436://iPhones_X_XS
            return 300
        case 2688://iPhone_XSMax
            return 5
        default://unknown
            return 5
        }
    }
}
