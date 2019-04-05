//
//  MainBuilder.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/11/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

final class MainBuilder {
    
    private enum Constants {
        static let home = "Home"
        static let help = "Help"
        
        static let homeIcon = UIImage(named: "HomeTabBarIcon")
        static let helpIcon = UIImage(named: "HelpTabBarIcon")
    }
    
    static func mainViewController() -> MainViewController {
        let mainViewController = MainViewController()
        
        let homeViewController = HomeBuilder.viewController()
        homeViewController.tabBarItem = UITabBarItem(title: Constants.home,
                                                     image: Constants.homeIcon,
                                                     tag: 0)
        
        let recentsViewController = RecentsBuilder.viewController()
        recentsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents,
                                                        tag: 1)
        
        let helpViewController = HelpBuilder.viewController()
        helpViewController.tabBarItem = UITabBarItem(title: Constants.help,
                                                     image: Constants.helpIcon,
                                                     tag: 2)
        
        let viewControllers = [homeViewController,
                               recentsViewController,
                               helpViewController]
        mainViewController.viewControllers = viewControllers.compactMap { $0.navigationController }
        
        return mainViewController
    }
}
