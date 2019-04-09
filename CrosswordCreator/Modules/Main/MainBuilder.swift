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
        static let help = "Help"
        static let helpIcon = UIImage(named: "HelpTabBarIcon")
    }
    
    static func mainViewController() -> MainViewController {
        let mainViewController = MainViewController()
        
        let recentsViewController = RecentsBuilder.viewController()
        recentsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents,
                                                        tag: 0)
        
        let helpViewController = HelpBuilder.viewController()
        helpViewController.tabBarItem = UITabBarItem(title: Constants.help,
                                                     image: Constants.helpIcon,
                                                     tag: 1)
        
        let viewControllers = [recentsViewController,
                               helpViewController]
        mainViewController.viewControllers = viewControllers.compactMap { $0.navigationController }
        
        return mainViewController
    }
}
