//
//  TabBarController.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Properties
    let homeIndex = 0
    let favoritesIndex = 1
    
    var defaultTabBarRect: CGRect?
    
    // MARK: - LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Actions
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
    
    func hideTabBarAnimated(hide: Bool, animateDuration: TimeInterval = 0.3) {
        let tabBarPositionY = tabBar.frame.height * 2
        UIView.animate(withDuration: animateDuration) {
            if hide {
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: tabBarPositionY)
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
