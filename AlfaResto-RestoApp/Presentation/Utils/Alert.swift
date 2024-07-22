//
//  Alert.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 19/06/24.
//

import Foundation
import UIKit

enum AlertType {
    case standard(title: String, msg: String)
    case customFunc(title: String, msg: String, onCancel: (() -> Void)?, onOkay: (() -> Void)?)
    case onOkayFunc(title: String, msg: String, onOkay: (() -> Void)?)
    case destructive(title: String, msg: String, destructiveTitle: String, destructiveAction: (() -> Void)?)
}

struct Alert {
    static func show(type: AlertType, viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        switch type {
            
        case let .standard(title, msg):
            alertController.title = title
            alertController.message = msg
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alertController.addAction(okAction)
            
        case let .customFunc(title, msg, onCancel, onOkay):
            alertController.title = title
            alertController.message = msg
            
            let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
                onOkay?()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                onCancel?()
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
        case let .onOkayFunc(title, msg, onOkay):
            alertController.title = title
            alertController.message = msg
            
            let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
                onOkay?()
            }
            
            alertController.addAction(okAction)
            
        case let .destructive(title, msg, destructiveTitle, destructiveAction):
            alertController.title = title
            alertController.message = msg
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { _ in
                destructiveAction?()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(destructiveAction)

        }
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
}
