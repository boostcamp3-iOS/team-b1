//
//  UIDevice+Extension.swift
//  UberEats
//
//  Created by admin on 28/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

//public extension UIDevice {
//
//    var iPhoneX: Bool {
//        return UIScreen.main.nativeBounds.height == 2436
//    }
//
//    var iPhone: Bool {
//        return UIDevice.current.userInterfaceIdiom == .phone
//    }
//
//    enum ScreenType: String {
//        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
//        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
//        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
//        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
//        case iPhones_X_XS = "iPhone X or iPhone XS"
//        case iPhone_XR = "iPhone XR"
//        case iPhone_XSMax = "iPhone XS Max"
//        case unknown
//    }
//
//    var screenType: ScreenType {
//        switch UIScreen.main.nativeBounds.height {
//        case 960:
//            return .iPhones_4_4S
//        case 1136:
//            return .iPhones_5_5s_5c_SE
//        case 1334:
//            return .iPhones_6_6s_7_8
//        case 1792:
//            return .iPhone_XR
//        case 1920, 2208:
//            return .iPhones_6Plus_6sPlus_7Plus_8Plus
//        case 2436:
//            return .iPhones_X_XS
//        case 2688:
//            return .iPhone_XSMax
//        default:
//            return .unknown
//        }
//    }
//}

/*
 extension UIDevice.ScreenType {
 func collectionCellSize(for section: Section) -> CGSize {
 switch (self, section) {
 case (.iPhones_4_4S, .bannerScroll):
 return CGSize(width: 100, height: 200)
 case (.iPhones_4_4S, .recommendFood):
 return CGSize(width: 100, height: 200)
 case (.iPhones_4_4S, .nearestRest):
 return CGSize(width: 100, height: 200)
 case (.iPhones_4_4S, .expectedTime):
 return CGSize(width: 100, height: 200)
 
 case (.iPhones_5_5s_5c_SE, .bannerScroll):
 return CGSize(width: 100, height: 250)
 case (.iPhones_5_5s_5c_SE, .recommendFood):
 return CGSize(width: 221, height: 200)
 case (.iPhones_5_5s_5c_SE, .nearestRest):
 return CGSize(width: 221, height: 250)
 case (.iPhones_5_5s_5c_SE, .expectedTime):
 return CGSize(width: 100, height: 250)
 
 case (.iPhones_6_6s_7_8, .bannerScroll):
 return CGSize(width: 100, height: 270)
 case (.iPhones_6_6s_7_8, .recommendFood):
 return CGSize(width: 100, height: 270)
 case (.iPhones_6_6s_7_8, .nearestRest):
 return CGSize(width: 100, height: 270)
 case (.iPhones_6_6s_7_8, .expectedTime):
 return CGSize(width: 100, height: 270)
 
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .bannerScroll):
 return CGSize(width: 100, height: 280)
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .recommendFood):
 return CGSize(width: 100, height: 280)
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .nearestRest):
 return CGSize(width: 100, height: 280)
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .expectedTime):
 return CGSize(width: 100, height: 280)
 
 case (.iPhones_X_XS, .bannerScroll):
 return CGSize(width: 100, height: 300)
 case (.iPhones_X_XS, .recommendFood):
 return CGSize(width: 100, height: 300)
 case (.iPhones_X_XS, .nearestRest):
 return CGSize(width: 100, height: 300)
 case (.iPhones_X_XS, .expectedTime):
 return CGSize(width: 100, height: 300)
 
 case (.iPhone_XR, .bannerScroll):
 return CGSize(width: 100, height: 310)
 case (.iPhone_XR, .recommendFood):
 return CGSize(width: 100, height: 310)
 case (.iPhone_XR, .nearestRest):
 return CGSize(width: 100, height: 310)
 case (.iPhone_XR, .expectedTime):
 return CGSize(width: 100, height: 310)
 
 case (.iPhone_XSMax, .bannerScroll):
 return CGSize(width: 100, height: 310)
 case (.iPhone_XSMax, .recommendFood):
 return CGSize(width: 100, height: 310)
 case (.iPhone_XSMax, .nearestRest):
 return CGSize(width: 100, height: 310)
 case (.iPhone_XSMax, .expectedTime):
 return CGSize(width: 100, height: 310)
 
 default: return CGSize(width: 100, height: 200)
 }
 }
 
 func tableCellSize(for section: Section) -> CGFloat {
 switch (self, section) {
 case (.iPhones_4_4S, .bannerScroll):
 return 200
 case (.iPhones_4_4S, .recommendFood):
 return 300
 case (.iPhones_4_4S, .nearestRest):
 return 400
 case (.iPhones_4_4S, .expectedTime):
 return 500
 
 case (.iPhones_5_5s_5c_SE, .bannerScroll):
 return 200
 case (.iPhones_5_5s_5c_SE, .recommendFood):
 return 300
 case (.iPhones_5_5s_5c_SE, .nearestRest):
 return 400
 case (.iPhones_5_5s_5c_SE, .expectedTime):
 return 500
 
 case (.iPhones_6_6s_7_8, .bannerScroll):
 return 200
 case (.iPhones_6_6s_7_8, .recommendFood):
 return 300
 case (.iPhones_6_6s_7_8, .nearestRest):
 return 400
 case (.iPhones_6_6s_7_8, .expectedTime):
 return 500
 
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .bannerScroll):
 return 200
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .recommendFood):
 return 300
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .nearestRest):
 return 400
 case (.iPhones_6Plus_6sPlus_7Plus_8Plus, .expectedTime):
 return 500
 
 case (.iPhones_X_XS, .bannerScroll):
 return 200
 case (.iPhones_X_XS, .recommendFood):
 return 300
 case (.iPhones_X_XS, .nearestRest):
 return 400
 case (.iPhones_X_XS, .expectedTime):
 return 500
 
 case (.iPhone_XR, .bannerScroll):
 return 200
 case (.iPhone_XR, .recommendFood):
 return 300
 case (.iPhone_XR, .nearestRest):
 return 400
 case (.iPhone_XR, .expectedTime):
 return 500
 
 case (.iPhone_XSMax, .bannerScroll):
 return 200
 case (.iPhone_XSMax, .recommendFood):
 return 300
 case (.iPhone_XSMax, .nearestRest):
 return 400
 case (.iPhone_XSMax, .expectedTime):
 return 500
 
 case (.unknown, _):
 return 200
 case (_, .newRest):
 return 300
 case (_, .discount):
 return 400
 case (_, .moreRest):
 return 400
 case (_, .searchAndSee):
 return 400
 default:
 return 300
 }
 }
 }
 */
