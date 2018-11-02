//
//  AppDelegate.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 19/10/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let controller = HomeBuilder.viewController()
        let navigationController = controller.navigationController
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
