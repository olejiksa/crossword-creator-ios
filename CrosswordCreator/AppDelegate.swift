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
    
    // MARK: Public Properties
    
    var window: UIWindow?
    let persistanceManager = PersistanceManager()
    
    
    // MARK: Private Properties
    
    private let xmlService = XmlService()
    private var launchedShortcutItem: UIApplicationShortcutItem?
    
    
    // MARK: Public

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            launchedShortcutItem = shortcutItem
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainBuilder.mainViewController()
        window?.makeKeyAndVisible()
        
        UIApplication.shared.windows.first?.backgroundColor = .white
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        persistanceManager.save()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        persistanceManager.save()
    }
    
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(item: shortcutItem))
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let shortcutItem = launchedShortcutItem else { return }
        handleShortcutItem(item: shortcutItem)
        launchedShortcutItem = nil
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        switch url.pathExtension {
        case FileExtension.list.rawValue:
            let words = xmlService.readList(from: url)
            
            var mutableUrl = url
            mutableUrl.deletePathExtension()
            
            persistanceManager.appendNewTermsList(name: mutableUrl.lastPathComponent,
                                                  words: words)
            
            return true
            
        case FileExtension.grid.rawValue:
            let layoutWords = xmlService.readGrid(from: url)
            
            var mutableUrl = url
            mutableUrl.deletePathExtension()
            
            persistanceManager.appendNewCrossword(name: mutableUrl.lastPathComponent,
                                                  words: layoutWords)
            
            return true
            
        default:
            return false
        }
    }
    
    
    // MARK: Private
    
    @discardableResult
    private func handleShortcutItem(item: UIApplicationShortcutItem) -> Bool {
        guard
            ShortcutIdentifier(fullNameForType: item.type) != nil,
            let mainVC = window?.rootViewController as? MainViewController
        else { return false }
        
        mainVC.selectedIndex = 0
        
        guard
            let nvc = mainVC.selectedViewController as? UINavigationController,
            let vc = nvc.viewControllers.first as? RecentsViewController
       else { return false }

        nvc.popToRootViewController(animated: false)
        vc.router?.wantsToCreate(with: vc)
        
        return true
    }
}
