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
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icons8-home-50"),
                                                      selectedImage: UIImage(named: "icons8-home-50"))

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

        let secondViewController = mainStoryBoard.instantiateViewController(withIdentifier: "searchView")
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icons8-home-50"),
                                                       selectedImage: UIImage(named: "icons8-home-50"))

        let thirdViewController = mainStoryBoard.instantiateViewController(withIdentifier: "orderHistory")
        thirdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icons8-home-50"),
                                                      selectedImage: UIImage(named: "icons8-home-50"))

        let fourthViewController = mainStoryBoard.instantiateViewController(withIdentifier: "myPage")
        fourthViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icons8-home-50"),
                                                       selectedImage: UIImage(named: "icons8-home-50"))

        let tabBarList = [firstViewController, secondViewController, thirdViewController, fourthViewController]

        self.viewControllers = tabBarList

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

}
