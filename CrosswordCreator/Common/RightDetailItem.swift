//
//  RightDetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit

public final class RightDetailItem {
    
    let title: String
    var subtitle: String
    public let actionBlock: ItemBlock?
    let hasDisclosureIndicator: Bool
    let accessibilityIdentifier: String?
    let isEnabled: Bool
    
    public init(title: String,
                subtitle: String,
                actionBlock: ItemBlock? = nil,
                hasDisclosureIndicator: Bool? = nil,
                accessibilityIdentifier: String? = nil,
                isEnabled: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.actionBlock = actionBlock
        self.hasDisclosureIndicator = hasDisclosureIndicator ?? (actionBlock != nil)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.isEnabled = isEnabled
    }
}

// MARK: - ItemProtocol

extension RightDetailItem: ItemProtocol {
    
    public var identifier: String { RightDetailCell.identifier }
}

// MARK: - Actionable

extension RightDetailItem: Actionable {}
