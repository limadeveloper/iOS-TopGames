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
    
    // MARK: - LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Actions
    private func updateUI() {
        
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
