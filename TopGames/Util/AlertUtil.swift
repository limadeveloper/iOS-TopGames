//
//  AlertUtil.swift
//  TopGames
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

struct AlertUtil {
 
    static func createAlert(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .alert, actions: [UIAlertAction]? = [UIAlertAction(title: LocalizedUtil.Text.alertButtonDone, style: .cancel, handler: nil)], target: UIViewController?, isPopover: Bool = false, buttonItem: UIBarButtonItem? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        if isPopover {
            alert.modalPresentationStyle = .popover
            let popover = alert.popoverPresentationController
            popover?.barButtonItem = buttonItem
            popover?.sourceRect = CGRect(x: 0, y: 10, width: 0, height: 0)
            popover?.backgroundColor = .white
        }
        
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
}
