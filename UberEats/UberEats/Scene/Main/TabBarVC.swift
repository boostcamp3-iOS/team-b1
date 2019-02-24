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

        let foodMarketViewController = UIStoryboard.ItemView.instantiateViewController(withIdentifier: "NavigationVC")
        foodMarketViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "btnTabbarHome"),
                                                           selectedImage: UIImage(named: "btnTabbarHome"))

        let searchViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "searchView")

        searchViewController.tabBarItem = UITabBarItem(title: nil,
                                                       image: UIImage(named: "btnTabbarSearchActive"),
                                                       selectedImage: UIImage(named: "btnTabbarSearchActive"))

        let orderHistoryViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "orderHistory")

        orderHistoryViewController.tabBarItem = UITabBarItem(title: nil,
                                                             image: UIImage(named: "btnTabbarOrder"),
                                                             selectedImage: UIImage(named: "btnTabbarOrder"))

        let myPageViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "myPage")

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

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    static var ItemView: UIStoryboard {
        return UIStoryboard(name: "ItemView", bundle: Bundle.main)
    }

    static var chatView: UIStoryboard {
        return UIStoryboard(name: "Chatting", bundle: Bundle.main)
    }

}
