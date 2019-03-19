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
        _ = handleShortcutItem(item: shortcutItem)
        launchedShortcutItem = nil
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let isHandled: Bool
        
        switch url.pathExtension {
        case FileExtension.list.rawValue:
            let words = xmlService.readList(from: url)
            print(words)
            isHandled = true
            
        case FileExtension.grid.rawValue:
            let layoutWords = xmlService.readGrid(from: url)
            print(layoutWords)
            
            var url2 = url
            url2.deletePathExtension()
            
            persistanceManager.appendNewCrossword(name: url2.lastPathComponent, words: layoutWords)
            
            isHandled = true
            
        default:
            isHandled = false
        }
        
        return isHandled
    }
    
    
    // MARK: Private
    
    private func handleShortcutItem(item: UIApplicationShortcutItem) -> Bool {
        guard ShortcutIdentifier(fullNameForType: item.type) != nil else { return false }
        
        if let mainVC = window?.rootViewController as? MainViewController {
            mainVC.selectedIndex = 1
            return true
        } else {
            return false
        }
    }
}
