//
//  AppDelegate.swift
//  Photography
//
//  Created by Ben Brackenbury on 17/06/2020.
//  Copyright © 2020 Ben Brackenbury. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        } else {
            //first launch -> set defaults
            UserDefaults.standard.set(35, forKey: "focalLength")
            UserDefaults.standard.set(0, forKey: "isCropped")
            UserDefaults.standard.set(1.1, forKey: "sensorCrop")
            
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
        
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
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == .main {
            builder.remove(menu: .edit)
            builder.remove(menu: .format)
        }
    }


}

