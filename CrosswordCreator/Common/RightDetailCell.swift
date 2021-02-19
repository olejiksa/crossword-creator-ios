//
//  RightDetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

public final class RightDetailCell: UITableViewCell {}

// MARK: - CellProtocol

extension RightDetailCell: CellProtocol {
    
    static public var identifier: String { "\(RightDetailCell.self)" }
    
    public func setup(with item: ItemProtocol) {
        guard let item = item as? RightDetailItem else { return }
        
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
        accessoryType = item.hasDisclosureIndicator ? .disclosureIndicator : .none
        
        isUserInteractionEnabled = item.isEnabled && item.actionBlock != nil
        textLabel?.isEnabled = item.isEnabled
        detailTextLabel?.isEnabled = item.isEnabled
        
        accessibilityIdentifier = item.accessibilityIdentifier
    }
}
