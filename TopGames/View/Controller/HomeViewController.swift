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
    private var configButtonItem = UIBarButtonItem()
    private var searchEnable = false
    
    private let kEmptyValue = 0
    private let kConfigButtonFontSize: CGFloat = 25
    private let kConfigButtonRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    private let kSearchBarTextFieldKey = "searchField"
    
    let cellName = "\(HomeCell.self)"
    let collectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (percentWidth: CGFloat, percentHeight: CGFloat)) = (1, 1, (0.33, 0.3))
    let refreshControl = UIRefreshControl()
    let homeViewModel = HomeViewModel()
    var searchController: UISearchController?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController?.isActive = false
        
        if let searchBar = searchController?.searchBar, searchEnable {
            searchBarCancelButtonClicked(searchBar)
            clearSearch()
        }
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
    
    private func updateUI() {
        
        navigationItem.title = LocalizedUtil.Text.homeNavigationTitle
        
        setConfigButton()
        setSearch()
        
        backgroundLabel.text = LocalizedUtil.Text.errorNoConnection
        backgroundLabel.addGestureRecognizer(tapGesture)
        
        setCollectionView()
    }
    
    @objc private func configActions() {
        let orderAction = UIAlertAction(title: LocalizedUtil.Text.alertButtonOrderByViewers, style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.homeViewModel.models = strongSelf.homeViewModel.models?.orderByViewers()
            strongSelf.collectionView.reloadData()
        }
        let dismissAction = UIAlertAction(title: LocalizedUtil.Text.alertButtonDone, style: .destructive, handler: nil)
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
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.tintColor = ColorUtil.navigationTint
        searchController?.searchBar.delegate = self
        
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
    
    private func clearSearch() {
        homeViewModel.searchModels = []
        searchEnable = false
        collectionView.reloadData()
    }
    
    private func setCollectionView() {
        
        refreshControl.tintColor = ColorUtil.lightGray
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
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
    
    private func reloadDataAfterClickOnFavoriteButton() {
        if searchEnable {
            homeViewModel.searchModels = homeViewModel.searchModels?.checkFavorites()
        } else {
            homeViewModel.models = homeViewModel.models?.checkFavorites()
        }
        collectionView.reloadData()
    }
}

// MARK: - UITabBarDelegate
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

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = searchEnable ? homeViewModel.searchModels : homeViewModel.models
        return (data ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? HomeCell
        
        guard let data = searchEnable ? homeViewModel.searchModels : homeViewModel.models else { return cell ?? UICollectionViewCell() }
        
        cell?.homeCellViewModel = HomeCellViewModel(model: data[indexPath.item])
        cell?.delegate = self
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let detailViewController = StoryboardUtil.detailViewController(), let data = searchEnable ? homeViewModel.searchModels : homeViewModel.models else { return }
        
        detailViewController.delegate = self
        detailViewController.detailViewModel = DetailViewModel(model: data[indexPath.item])
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = nil
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let items = homeViewModel.models, items.count > kEmptyValue, !searchEnable else { return }
        let lastIndex = items.count - 1
        if indexPath.item == lastIndex {
            loadData(with: homeViewModel.pageIndex) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.collectionView.reloadData()
            }
        }
    }
}

// MARK: - HomeCellDelegate
extension HomeViewController: HomeCellDelegate {
    func homeCell(_ homeCell: HomeCell, didSelect favoriteButton: UIButton) {
        reloadDataAfterClickOnFavoriteButton()
    }
}

// MARK: - DetailViewControllerDelegate
extension HomeViewController: DetailViewControllerDelegate {
    func detailViewController(_ detailViewController: DetailViewController, didSelect favoriteButton: UIButton) {
        reloadDataAfterClickOnFavoriteButton()
    }
}

// MARK: - UISearchBarDelegate, UISearchControllerDelegate and UISearchResultsUpdating
extension HomeViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        homeViewModel.searchModels = []
        
        guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else { return }
        
        for model in (homeViewModel.models ?? []) {
            if (model.game?.name.lowercased() ?? "").contains(searchText) {
                homeViewModel.searchModels?.append(model)
            }
        }
        
        searchEnable = searchController.searchBar.showsCancelButton
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        collectionView.allowsSelection = true
        clearSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        collectionView.allowsSelection = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        clearSearch()
        collectionView.allowsSelection = false
        searchBar.showsCancelButton = true
    }
}
