//
//  FavoritesViewController.swift
//  TopGames
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import KTCenterFlowLayout

class FavoritesViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let kEmptyValue = 0
    
    let homeViewModel = HomeViewModel()
    let refreshControl = UIRefreshControl()
    let cellName = "\(HomeCell.self)"
    let collectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.33, 0.3))
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    @IBAction private func loadData() {
        homeViewModel.loadFavoriteGames()
        refreshControl.endRefreshing()
        updateUI()
    }
    
    private func updateUI() {
        
        navigationItem.title = LocalizedUtil.Text.favoritesNavigationTitle
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = nil
        }
        
        backgroundLabel.text = LocalizedUtil.Text.errorNoData
        backgroundLabel.addGestureRecognizer(tapGesture)
        
        if (homeViewModel.favoritesModels ?? []).count > 0 {
            view.bringSubview(toFront: collectionView)
            collectionView.alpha = CGFloat(homeViewModel.alpha.max)
            backgroundLabel.isHidden = true
        } else {
            view.bringSubview(toFront: backgroundLabel)
            collectionView.alpha = CGFloat(homeViewModel.alpha.min)
            backgroundLabel.isHidden = false
        }
        
        collectionView.reloadData()
    }
    
    private func setCollectionView() {
        
        refreshControl.tintColor = ColorUtil.lightGray
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = collectionlayout.minInteritemSpacing
        layout.minimumLineSpacing = collectionlayout.minLineSpacing
        
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width * collectionlayout.size.percentWidth,
            height: UIScreen.main.bounds.height * collectionlayout.size.percentHeight
        )
        
        collectionView.collectionViewLayout = layout
        collectionView.refreshControl = refreshControl
    }
    
    private func reloadDataAfterClickOnFavoriteButton() {
        homeViewModel.favoritesModels = homeViewModel.favoritesModels?.checkFavorites()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = homeViewModel.favoritesModels
        return (data ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? HomeCell
        
        guard let data = homeViewModel.favoritesModels else { return cell ?? UICollectionViewCell() }
        
        cell?.homeCellViewModel = HomeCellViewModel(model: data[indexPath.item])
        cell?.delegate = self
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let detailViewController = StoryboardUtil.detailViewController(), let data = homeViewModel.favoritesModels else { return }
        
        detailViewController.delegate = self
        detailViewController.detailViewModel = DetailViewModel(model: data[indexPath.item])
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - HomeCellDelegate
extension FavoritesViewController: HomeCellDelegate {
    func homeCell(_ homeCell: HomeCell, didSelect favoriteButton: UIButton) {
        reloadDataAfterClickOnFavoriteButton()
    }
}

// MARK: - DetailViewControllerDelegate
extension FavoritesViewController: DetailViewControllerDelegate {
    func detailViewController(_ detailViewController: DetailViewController, didSelect favoriteButton: UIButton) {
        reloadDataAfterClickOnFavoriteButton()
    }
}
