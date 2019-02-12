//
//  StoreModel.swift
//  UberEats
//
//  Created by 이혜주 on 12/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

let buttonSize: CGFloat = 25

enum CellId: String {
    case temp = "tempId"
    case stretchyHeader = "stretchyHeaderId"
    case tempHeader = "tempHeaderId"
    case timeAndLocation = "timeAndLocationId"
    case menu = "menuId"
    case menuCategory = "menuCategoryId"
    case menuDetail = "menuDetailId"
    case menuSection = "menuSectionId"
}

enum XibName: String {
    case timeAndLocation = "TimeAndLocationCollectionViewCell"
    case search = "SearchCollectionViewCell"
    case menuSection = "MenuSectionView"
    case menuCategory = "MenuCategoryCollectionViewCell"
}

enum NumberOfSection: Int {
    case menuBar = 1
    case collectionView = 7
}

enum SectionInStoreView: Int {
    case stretchyHeader = 0
    case timeAndLocation
    case menu
    // 예비
    case foodOne
    case foodTwo
    case foodThree
    case foodFour
}

struct ValuesForStoreView {
    static let widthMultiplier: CGFloat = 0.9
    static let heightMultiplier: CGFloat = 0.5
    static let distanceBetweenHeightAfterStick: CGFloat = 38
}

struct ValuesForCollectionView {
    static let menuBarMinSpacing: CGFloat = 0
    static let menuBarZeroAlpha: CGFloat = 0
    static let menuBarFullAlpha: CGFloat = 1

    static let menuBarZeroInset: CGFloat = 0
    static let menuBarLeftInset: CGFloat = 20
    static let menuBarRightInset: CGFloat = 10

    static let menuBarHeightConstant: CGFloat = 60

    static let baseNumberOfCell: Int = 1
}

struct ValuesForButton {
    static let backAndLikeTopConstant: CGFloat = 10
    static let backLeadingConstant: CGFloat = 15
    static let likeTrailingConstant: CGFloat = 15
}

struct ValuesForFloatingView {
    static let fullMultiplier: CGFloat = 1
    static let widthPadding: CGFloat = 10
    static let leadingConstant: CGFloat = 0
    static let heightConstant: CGFloat = 35
}

struct HeightsOfHeader {
    static let stretchy: CGFloat = 283
    static let timeAndLocation: CGFloat = 1
    static let menuBarAndMenu: CGFloat = 0
    static let food: CGFloat = 0
//    static let menus: CGFloat = 70
}

struct HeightsOfCell {
    static let menuBarAndMenu: CGFloat = 50

    static let timeAndLocationMultiplier: CGFloat = 0.15
    static let food: CGFloat = 50
    static let empty: CGFloat = 0
}

struct DistanceBetween {
    static let menuAndRest = 3
    static let titleAndFoodCell = 1
}

struct AnimationValues {
    static let likeButtonChangeLimit: CGFloat = 320
    static let scrollLimit: CGFloat = 171
    static let delay: TimeInterval = 0
    static let duration: TimeInterval = 0.3
}
