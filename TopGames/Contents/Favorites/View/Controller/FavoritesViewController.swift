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
  
  // MARK: - Constants
  private let kCollectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.33, 0.3))
  private let kCollectionlayoutiPad: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.165, 0.35))
  
  // MARK: - Properties
  @IBOutlet weak var tapGesture: UITapGestureRecognizer!
  @IBOutlet weak var backgroundLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let homeViewModel = HomeViewModel()
  let refreshControl = UIRefreshControl()
  
  // swiftlint:disable weak_delegate
  var dataSourceAndDelegate: FavoritesDataSourceAndDelegate?
  
  // MARK: - Overrides
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
  
  // MARK: - Private Methods
  private func updateUI() {
    
    navigationItem.title = LocalizedUtil.Text.favoritesNavigationTitle
    
    if #available(iOS 11.0, *) {
      navigationItem.searchController = nil
    }
    
    backgroundLabel.text = LocalizedUtil.Text.errorNoData
    backgroundLabel.addGestureRecognizer(tapGesture)
    
    if (homeViewModel.favoritesModels ?? []).count > Int() {
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
    
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    let layout = KTCenterFlowLayout()
    
    layout.minimumInteritemSpacing = isIpad ? kCollectionlayoutiPad.minInteritemSpacing : kCollectionlayout.minInteritemSpacing
    layout.minimumLineSpacing = isIpad ? kCollectionlayoutiPad.minLineSpacing : kCollectionlayout.minLineSpacing
    
    layout.itemSize = CGSize(
      width: UIScreen.main.bounds.width * (isIpad ? kCollectionlayoutiPad.size.percentWidth : kCollectionlayout.size.percentWidth),
      height: UIScreen.main.bounds.height * (isIpad ? kCollectionlayoutiPad.size.percentHeight : kCollectionlayout.size.percentHeight)
    )
    
    collectionView.collectionViewLayout = layout
    collectionView.refreshControl = refreshControl
    
    dataSourceAndDelegate = FavoritesDataSourceAndDelegate(with: self)
    collectionView.dataSource = dataSourceAndDelegate
    collectionView.delegate = dataSourceAndDelegate
  }
  
  // MARK: - Public Methods
  func reloadDataAfterClickOnFavoriteButton() {
    homeViewModel.favoritesModels = homeViewModel.favoritesModels?.checkFavorites()
    collectionView.reloadData()
  }
}
