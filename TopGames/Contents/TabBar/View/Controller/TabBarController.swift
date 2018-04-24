//
//  TabBarController.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

private let kTabBarYMultiplierValue: CGFloat = 2
private let kTabBarHidderAnimatedDurationValue: TimeInterval = 0.3

class TabBarController: UITabBarController {
  
  // MARK: - Constants
  let homeIndex = Int()
  let favoritesIndex = 1
  
  // MARK: - Properties
  var defaultTabBarRect: CGRect?
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  // MARK: - Private Methods
  private func updateUI() {
    
    defaultTabBarRect = tabBar.frame
    
    guard let items = tabBar.items else { return }
    
    if items.count > homeIndex {
      let homeTab = items[homeIndex]
      homeTab.title = LocalizedUtil.Text.homeNavigationTitle
    }
    
    if items.count > favoritesIndex {
      let homeTab = items[favoritesIndex]
      homeTab.title = LocalizedUtil.Text.favoritesNavigationTitle
    }
    
    selectedIndex = homeIndex
  }
}

// MARK: - Extensions
extension UITabBarController {
  
  func hideTabBarAnimated(hide: Bool, animateDuration: TimeInterval = kTabBarHidderAnimatedDurationValue) {
    let tabBarPositionY = tabBar.frame.height * kTabBarYMultiplierValue
    UIView.animate(withDuration: animateDuration) {
      if hide {
        self.tabBar.transform = CGAffineTransform(translationX: CGFloat(), y: tabBarPositionY)
        self.tabBar.isHidden = true
      } else {
        self.tabBar.isHidden = false
        self.tabBar.transform = .identity
      }
    }
  }
  
  func isTabBarVisible() -> Bool {
    return !tabBar.isHidden
  }
}
