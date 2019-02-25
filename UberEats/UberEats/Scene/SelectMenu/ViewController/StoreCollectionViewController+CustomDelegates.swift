//
//  StoreCollectionViewController+CustomDelegates.swift
//  UberEats
//
//  Created by 이혜주 on 25/02/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import Common
import Service
import DependencyContainer
import ServiceInterface

extension StoreCollectionViewController: SearchBarDelegate {
    func showSeachBar() {
        let searchVC = UIStoryboard.main.instantiateViewController(withIdentifier: "searchViewController")

        addChild(searchVC)
        searchVC.view.frame = view.frame

        view.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)
    }
}

extension StoreCollectionViewController: OrderButtonClickable {

    func onClickedOrderButton(_ sender: Any) {
        let cartStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        guard let cartViewController = cartStoryboard.instantiateViewController(withIdentifier: "CartVC")
            as? CartViewController else {
                return
        }

        guard let store = store else {
            return
        }

        let storeInfo = StoreInfoModel.init(name: store.name, deliveryTime: store.deliveryTime, location: store.location)
        let deliveryInfoModel = DeilveryInfoModel.init(locationImage: "https://github.com/boostcamp3-iOS/team-b1/blob/master/images/FoodMarket/airInTheCafe.jpeg?raw=true",
                                                       detailedAddress: "서울특별시 강남구 역삼1동 강남대로 382",
                                                       address: "메리츠 타워",
                                                       deliveryMethod: .pickUpOutside,
                                                       roomNumber: 101)

        cartViewController.cartModel = CartModel.init(storeInfo: storeInfo, deilveryInfo: deliveryInfoModel, foodOrderedInfo: nil)

        cartViewController.orderInfoModels = orderFoods

        cartViewController.storeImageURL = store.lowImageURL

        navigationController?.pushViewController(cartViewController, animated: true)
    }

}

extension StoreCollectionViewController: FoodSelectable {

    func foodSelected(orderInfo: OrderInfoModel) {
        orderFoods.append(orderInfo)
        totalPrice += orderInfo.amount * orderInfo.price
        moveCartView.moveCartButton.setAmount(price: totalPrice)

        if !orderFoods.isEmpty {
            moveCartView.isHidden = false
        }
    }

}
