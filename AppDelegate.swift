//
//  AppDelegate.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-07-30.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        initializePayPal()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - initialize PayPal
    func initializePayPal() {
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction : "AQbvSsj6c6bkwsQotIWFQAWXYAt-bOnQwRtQQsJXat_5GqrIX49h2OpVNoJKMuT1bgHXCbg7ZOHovN5p", PayPalEnvironmentSandbox: "sb-6cwwi3221823@business.example.com"])
    }


}
