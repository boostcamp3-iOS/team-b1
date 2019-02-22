//
//  TabBarVC.swift
//  UberEats
//
//  Created by admin on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let foodMarketStroyBoard = UIStoryboard(name: "ItemView", bundle: nil)

        let foodMarketViewController = foodMarketStroyBoard.instantiateViewController(withIdentifier: "NavigationVC")
        foodMarketViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "btnTabbarHome"),
                                                           selectedImage: UIImage(named: "btnTabbarHome"))

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

        let searchViewController = mainStoryBoard.instantiateViewController(withIdentifier: "searchView")

        searchViewController.tabBarItem = UITabBarItem(title: nil,
                                                       image: UIImage(named: "btnTabbarSearchActive"),
                                                       selectedImage: UIImage(named: "btnTabbarSearchActive"))

        let orderHistoryViewController = mainStoryBoard.instantiateViewController(withIdentifier: "orderHistory")

        orderHistoryViewController.tabBarItem = UITabBarItem(title: nil,
                                                             image: UIImage(named: "btnTabbarOrder"),
                                                             selectedImage: UIImage(named: "btnTabbarOrder"))

        let myPageViewController = mainStoryBoard.instantiateViewController(withIdentifier: "myPage")

        myPageViewController.tabBarItem = UITabBarItem(title: nil,
                                                       image: UIImage(named: "btnTabbarMypageActive"),
                                                       selectedImage: UIImage(named: "btnTabbarMypageActive"))

        let tabBarList = [foodMarketViewController, searchViewController, orderHistoryViewController, myPageViewController]

        self.viewControllers = tabBarList

        tabBar.tintColor = .black

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

}
