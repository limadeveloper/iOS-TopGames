//
//  HomeViewController.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import KTCenterFlowLayout

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let tabBar = TabBarController()
    private let emptyValue = 0
    
    let refreshControl = UIRefreshControl()
    let homeViewModel = HomeViewModel()
    let collectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.33, 0.3))
    let cellName = "\(HomeCell.self)"
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    @IBAction private func reloadData() {
        homeViewModel.models = []
        collectionView.reloadData()
        loadData { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }
    }
    
    private func setCollectionView() {
        
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = collectionlayout.minInteritemSpacing
        layout.minimumLineSpacing = collectionlayout.minLineSpacing
        
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width * collectionlayout.size.percentWidth,
            height: UIScreen.main.bounds.height * collectionlayout.size.percentHeight
        )
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
    }
    
    private func updateUI() {
        
        navigationItem.title = LocalizedUtil.Text.homeNavigationTitle
        
        backgroundLabel.text = LocalizedUtil.Text.errorNoConnection
        backgroundLabel.addGestureRecognizer(tapGesture)
        
        refreshControl.tintColor = ColorUtil.lightGray
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        setCollectionView()
    }
    
    private func loadData(with pageIndex: Int = 0, completion: (() -> Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        homeViewModel.loadData(with: pageIndex) { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let strongSelf = self else { return }
            if strongSelf.homeViewModel.collectionAlpha == strongSelf.homeViewModel.alpha.max {
                strongSelf.view.bringSubview(toFront: strongSelf.collectionView)
                strongSelf.backgroundLabel.isHidden = true
            } else {
                strongSelf.view.bringSubview(toFront: strongSelf.backgroundLabel)
                strongSelf.backgroundLabel.isHidden = false
            }
            strongSelf.refreshControl.endRefreshing()
            strongSelf.collectionView.alpha = CGFloat(strongSelf.homeViewModel.collectionAlpha)
            completion?()
        }
    }
}

// MARK: UITabBarDelegate
extension HomeViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = tabBar.items?.index(of: item) ?? self.tabBar.homeIndex
        switch selectedIndex {
        case self.tabBar.homeIndex:
            navigationItem.title = LocalizedUtil.Text.homeNavigationTitle
        case self.tabBar.favoritesIndex:
            navigationItem.title = LocalizedUtil.Text.favoritesNavigationTitle
        default:
            break
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (homeViewModel.models ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? HomeCell
        if let selectedModel = homeViewModel.models?[indexPath.item] {
            cell?.homeCellViewModel = HomeCellViewModel(model: selectedModel)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let items = homeViewModel.models, items.count > emptyValue else { return }
        let lastIndex = items.count - 1
        if indexPath.item == lastIndex {
            loadData(with: homeViewModel.pageIndex) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.collectionView.reloadData()
            }
        }
    }
}
