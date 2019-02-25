//
//  AppDelegate.swift
//  UberEats
//
//  Created by 장공의 on 24/01/2019.
//  Copyright © 2019 team-b1. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let locationManager = CLLocationManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyAphHHY5LL8tq4QOepg2cCFASelCbSLa0E")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let ChatVC = UIStoryboard.chatView.instantiateViewController(withIdentifier: "ChattingViewController")
        
        window?.rootViewController = ChatVC

        window?.makeKeyAndVisible()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
