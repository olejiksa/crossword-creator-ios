//
//  ServiceLocator.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 16/04/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

final class ServiceLocator {
    
    static var xmlService: XmlServiceProtocol = {
        return XmlService()
    }()
}
