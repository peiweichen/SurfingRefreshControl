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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = DemoViewController()
        self.window?.makeKeyAndVisible()
        return true
    }


}

