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
        
        let ItemViewStoryBoard = UIStoryboard(name: "ItemView", bundle: nil)
        let firstViewController = ItemViewStoryBoard.instantiateViewController(withIdentifier: "itemView")
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icMain"), selectedImage: UIImage(named: "1"))
        
        let tabBarList = [firstViewController]
        self.viewControllers = tabBarList
    
        //self.view.superview?.addSubview(self.tabBar)
        //self.view.addSubview(self.tabBar)
        //self.view.bringSubviewToFront(self.tabBar)
        //self.view.sendSubviewToBack(self.tabBar)
        
        self.tabBar.barTintColor = #colorLiteral(red: 1, green: 0.1187493313, blue: 0.5523979556, alpha: 1)
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.barStyle = .black
        
        for i in self.view.subviews {
            print("\(i.description) 탭바 컨트롤러")
        }
        
        print("\(self.view.subviews.count) 탭바 컨트롤러 개수")
        self.selectedIndex = 1
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }


}
