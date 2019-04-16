//
//  ServiceLocator.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ServiceLocator {
    
    static var persistanceService: PersistanceServiceProtocol = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manager = appDelegate.persistanceManager
        
        return PersistanceService(persistanceManager: manager)
    }()
    
    static var xmlService: XmlServiceProtocol = {
        return XmlService()
    }()
}
