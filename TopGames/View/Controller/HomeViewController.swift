//
//  HomeViewController.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let tabBar = TabBarController()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction private func reloadData() {
        
    }
    
    private func updateUI() {
        
    }
}

extension HomeViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = tabBar.items?.index(of: item) ?? self.tabBar.homeIndex
        switch selectedIndex {
        case self.tabBar.homeIndex: navigationItem.title = LocalizedUtil.Text.homeNavigationTitle
        case self.tabBar.favoritesIndex: navigationItem.title = LocalizedUtil.Text.favoritesNavigationTitle
        default:
            break
        }
    }
}
