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
  
  // MARK: - Constants
  private let kConfigButtonFontSize: CGFloat = 25
  private let kConfigButtonRect = CGRect(x: CGFloat(), y: CGFloat(), width: 25, height: 25)
  private let kSearchBarTextFieldKey = "searchField"
  private let collectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.33, 0.3))
  private let collectionlayoutiPad: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.165, 0.35))
  
  // MARK: - Properties
  @IBOutlet weak var tapGesture: UITapGestureRecognizer!
  @IBOutlet weak var backgroundLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var configButtonItem = UIBarButtonItem()
  
  let refreshControl = UIRefreshControl()
  let homeViewModel = HomeViewModel()
  var searchController: UISearchController?
  var searchEnable = false
  
  // swiftlint:disable weak_delegate
  var dataSourceAndDelegate: HomeDataSourceAndDelegate?
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    reloadDataAfterClickOnFavoriteButton()
    
    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchController
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let searchBar = searchController?.searchBar, searchEnable {
      dataSourceAndDelegate?.searchBarCancelButtonClicked(searchBar)
      clearSearch()
    }
    
    searchController?.isActive = false
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
  
  // MARK: - Private Methods
  private func updateUI() {
    
    navigationItem.title = LocalizedUtil.Text.homeNavigationTitle
    
    setDataSourceAndDelegate()
    setConfigButton()
    setSearch()
    
    backgroundLabel.text = LocalizedUtil.Text.errorNoConnection
    
    if homeViewModel.network.isConnectedToInternet() {
      backgroundLabel.text = LocalizedUtil.Text.errorNoData
    }
    
    backgroundLabel.addGestureRecognizer(tapGesture)
    
    setCollectionView()
  }
  
  @objc private func configActions() {
    let orderAction = UIAlertAction(title: LocalizedUtil.Text.alertButtonOrderByViewers, style: .default) { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.homeViewModel.models = strongSelf.homeViewModel.models?.orderByViewers()
      strongSelf.collectionView.reloadData()
    }
    let dismissAction = UIAlertAction(title: LocalizedUtil.Text.alertButtonDone, style: .cancel, handler: nil)
    AlertUtil.createAlert(
      title: LocalizedUtil.Text.homeNavigationTitle,
      style: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet,
      actions: [orderAction, dismissAction],
      target: self
    )
  }
  
  private func setConfigButton() {
    
    let button = UIButton(frame: kConfigButtonRect)
    button.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: kConfigButtonFontSize)
    button.setTitle(String.fontAwesomeIcon(FontUtil.FontIcon.FontAwesome.cogs), for: .normal)
    button.setTitleColor(ColorUtil.navigationTint, for: .normal)
    button.addTarget(self, action: #selector(configActions), for: .touchUpInside)
    
    configButtonItem = UIBarButtonItem(customView: button)
    
    navigationItem.rightBarButtonItem = configButtonItem
  }
  
  private func setSearch() {
    
    searchController = UISearchController(searchResultsController: nil)
    searchController?.loadViewIfNeeded()
    searchController?.searchResultsUpdater = dataSourceAndDelegate
    searchController?.delegate = dataSourceAndDelegate
    searchController?.dimsBackgroundDuringPresentation = false
    searchController?.searchBar.sizeToFit()
    searchController?.searchBar.barStyle = .black
    searchController?.searchBar.tintColor = ColorUtil.navigationTint
    searchController?.searchBar.delegate = dataSourceAndDelegate
    
    if let textField = searchController?.searchBar.value(forKey: kSearchBarTextFieldKey) as? UITextField {
      textField.keyboardAppearance = .dark
      textField.textColor = ColorUtil.navigationTint
    }
    
    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchController
    } else if let searchBar = searchController?.searchBar {
      collectionView.addSubview(searchBar)
    }
  }
  
  private func setDataSourceAndDelegate() {
    dataSourceAndDelegate = HomeDataSourceAndDelegate(with: self)
  }
  
  private func setCollectionView() {
    
    refreshControl.tintColor = ColorUtil.lightGray
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    
    let isIpad = UIDevice.current.userInterfaceIdiom == .pad
    let layout = KTCenterFlowLayout()
    
    layout.minimumInteritemSpacing = isIpad ? collectionlayoutiPad.minInteritemSpacing : collectionlayout.minInteritemSpacing
    layout.minimumLineSpacing = isIpad ? collectionlayoutiPad.minLineSpacing : collectionlayout.minLineSpacing
    
    layout.itemSize = CGSize(
      width: UIScreen.main.bounds.width * (isIpad ? collectionlayoutiPad.size.percentWidth : collectionlayout.size.percentWidth),
      height: UIScreen.main.bounds.height * (isIpad ? collectionlayoutiPad.size.percentHeight : collectionlayout.size.percentHeight)
    )
    
    collectionView.collectionViewLayout = layout
    collectionView.refreshControl = refreshControl
    collectionView.dataSource = dataSourceAndDelegate
    collectionView.delegate = dataSourceAndDelegate
  }
  
  // MARK: - Public Methods
  func reloadDataAfterClickOnFavoriteButton() {
    if searchEnable {
      homeViewModel.searchModels = homeViewModel.searchModels?.checkFavorites()
    } else {
      homeViewModel.models = homeViewModel.models?.checkFavorites()
    }
    collectionView.reloadData()
  }
  
  func loadData(with pageIndex: Int = Int(), completion: (() -> Void)?) {
    
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
  
  func clearSearch() {
    homeViewModel.searchModels = []
    searchEnable = false
    collectionView.reloadData()
  }
}
