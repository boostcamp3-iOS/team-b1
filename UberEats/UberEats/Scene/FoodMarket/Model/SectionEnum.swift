//
//  SectionEnum.swift
//  UberEats
//
//  Created by admin on 31/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//
import UIKit

enum Section: Int, CaseIterable {
    case bannerScroll = 0
    case recommendFood = 1
    case nearestRest = 2
    case expectedTime = 3
    case newRest = 4
    case discount = 5
    case moreRest = 6
    case searchAndSee = 7

    var identifier: String {
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

    var nibName: String {
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

    var numberOfSection: Int {
        switch self {
        case .recommendFood, .nearestRest, .expectedTime, .newRest, .discount, .searchAndSee:
            return 1
        case .bannerScroll:
            return 0
        default:
            return 2
        }
    }

    func heightOfTableViewCell(_ height: CGFloat) -> CGFloat {
        switch self {
        case .recommendFood, .nearestRest, .expectedTime, .newRest, .moreRest:
            return height * 0.5
        case .discount:
            return height * 0.14
        case .searchAndSee:
            return height * 0.2
        case .bannerScroll:
            return 0
        default:
            return height
        }
    }

    var getEdgeInset: UIEdgeInsets {
        switch self {
        case .bannerScroll:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .recommendFood:
            return UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
        case .nearestRest:
            return UIEdgeInsets(top: 30, left: 24, bottom: 24, right: 30)
        case .expectedTime:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        case .newRest:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        default:
            return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        }
    }

}
