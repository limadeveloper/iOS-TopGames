//
//  AlertUtil.swift
//  TopGames
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

// MARK: - Constants
private let kPopoverRect = CGRect(x: CGFloat(), y: 10, width: CGFloat(), height: CGFloat())

struct AlertUtil {
  
  // MARK: - Public Methods
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
      popover?.sourceRect = kPopoverRect
      popover?.backgroundColor = .white
    }
    
    DispatchQueue.main.async {
      target?.present(alert, animated: true, completion: nil)
    }
  }
  
  static func showAlertWarningAboutInternetConnection(in target: UIViewController?) -> UIAlertController {
    let alert = UIAlertController(title: "☹︎ \(LocalizedUtil.Text.errorNoConnection)", message: LocalizedUtil.Text.errorCheckConnection, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
    DispatchQueue.main.async {
      target?.present(alert, animated: true, completion: nil)
    }
    return alert
  }
}
