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

        let itemStroyBoard = UIStoryboard(name: "ItemView", bundle: nil)
        let firstViewController = itemStroyBoard.instantiateViewController(withIdentifier: "NavigationVC")
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "btnTabbarHome"),
                                                      selectedImage: UIImage(named: "btnTabbarHome"))

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

        let secondViewController = mainStoryBoard.instantiateViewController(withIdentifier: "searchView")

        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "btnTabbarSearchActive"),
                                                       selectedImage: UIImage(named: "btnTabbarSearchActive"))

        let thirdViewController = mainStoryBoard.instantiateViewController(withIdentifier: "orderHistory")
        thirdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "btnTabbarOrder"),
                                                      selectedImage: UIImage(named: "btnTabbarOrder"))

        let fourthViewController = mainStoryBoard.instantiateViewController(withIdentifier: "myPage")
        fourthViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "btnTabbarMypageActive"),
                                                       selectedImage: UIImage(named: "btnTabbarMypageActive"))

        let tabBarList = [firstViewController, secondViewController, thirdViewController, fourthViewController]

        self.viewControllers = tabBarList

        tabBar.tintColor = .black

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

}
