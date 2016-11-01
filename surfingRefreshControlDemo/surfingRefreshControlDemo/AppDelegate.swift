//
//  AppDelegate.swift
//  surfingRefreshControlDemo
//
//  Created by chenpeiwei on 6/10/16.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = DemoViewController()
        self.window?.makeKeyAndVisible()
        return true
    }


}

