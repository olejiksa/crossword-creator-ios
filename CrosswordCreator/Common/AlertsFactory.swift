//
//  AlertsFactory.swift
//  CrosswordCreator
//
//  Created by Oleg Samoylov on 09/03/2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AlertsFactory {
    
    private enum Actions {
        
        case ok
        case yesNo
        case yesNoCancel
    }
    
    static func damagedFile(_ vc: UIViewController) {
        let title = "Damaged File"
        let message = "Unfortunately, we can't show you this file"
        
        show(vc, title: title, message: message)
    }
    
    static func crosswordIsFilledCorrectly(_ vc: UIViewController) {
        let title = "Filled Correctly"
        let message = "Wonderful! You've filled the crossword absolutely true"
        
        show(vc, title: title, message: message)
    }
    
    static func crosswordIsFilledIncorrectly(_ vc: UIViewController) {
        let title = "Not Filled Correctly"
        let message = "Mistakes had been made. Do you want to see them?"
        
        show(vc, title: title, message: message, actions: .yesNo)
    }
    
    
    // MARK: Private
    
    private static func show(_ vc: UIViewController,
                             title: String,
                             message: String,
                             actions: Actions? = .ok) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        if let actions = actions {
            switch actions {
            case .ok:
                let okAction = UIAlertAction(title: "OK", style: .default)
                
                alertController.addAction(okAction)
                
            case .yesNo:
                let yesAction = UIAlertAction(title: "Yes", style: .default)
                let noAction = UIAlertAction(title: "No", style: .cancel)
                
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                
            case .yesNoCancel:
                let yesAction = UIAlertAction(title: "Yes", style: .default)
                let noAction = UIAlertAction(title: "No", style: .cancel)
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
                
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                alertController.addAction(cancelAction)
            }
        }
        
        vc.present(alertController)
    }
}
