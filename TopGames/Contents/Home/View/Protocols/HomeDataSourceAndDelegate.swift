//
//  HomeDataSourceAndDelegate.swift
//  TopGames
//
//  Created by John Lima on 23/04/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

class HomeDataSourceAndDelegate: NSObject {
  
  // MARK: - Constants
  private let kCellName = "\(HomeCell.self)"
  private let kTimeIntervalToDismissAlertWarning: TimeInterval = 5
  
  // MARK: - Properties
  private var controller: HomeViewController?
  private var alertWarningAboutConnection: UIAlertController?
  
  // MARK: - Initializers
  init(with target: HomeViewController) {
    controller = target
  }
}

// MARK: - Extensions
extension HomeDataSourceAndDelegate: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let data = controller?.searchEnable == true ? controller?.homeViewModel.searchModels : controller?.homeViewModel.models
    return (data ?? []).count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellName, for: indexPath) as? HomeCell
    
    guard let data = controller?.searchEnable == true ? controller?.homeViewModel.searchModels : controller?.homeViewModel.models else { return cell ?? UICollectionViewCell() }
    
    cell?.homeCellViewModel = HomeCellViewModel(model: data[indexPath.item])
    cell?.delegate = self
    
    return cell ?? UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let detailViewController = StoryboardUtil.detailViewController(), let data = controller?.searchEnable == true ? controller?.homeViewModel.searchModels : controller?.homeViewModel.models else { return }
    
    detailViewController.delegate = self
    detailViewController.detailViewModel = DetailViewModel(model: data[indexPath.item])
    
    if #available(iOS 11.0, *) {
      controller?.navigationItem.searchController = nil
    }
    
    controller?.navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    guard let items = controller?.homeViewModel.models, items.count > Int(), controller?.searchEnable == false else { return }
    
    let lastIndex = items.count - 1
    
    if indexPath.item == lastIndex {
      
      guard controller?.homeViewModel.network.isConnectedToInternet() == true else {
        alertWarningAboutConnection = AlertUtil.showAlertWarningAboutInternetConnection(in: controller)
        Timer.scheduledTimer(withTimeInterval: kTimeIntervalToDismissAlertWarning, repeats: false) { [weak self] timer in
          guard let strongSelf = self else { return }
          strongSelf.alertWarningAboutConnection?.dismiss(animated: true) {
            timer.invalidate()
          }
        }
        return
      }
      
      controller?.loadData(with: controller?.homeViewModel.pageIndex ?? Int()) { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.controller?.collectionView.reloadData()
      }
    }
  }
}

extension HomeDataSourceAndDelegate: HomeCellDelegate {
  func homeCell(_ homeCell: HomeCell, didSelect favoriteButton: UIButton) {
    controller?.reloadDataAfterClickOnFavoriteButton()
  }
}

extension HomeDataSourceAndDelegate: DetailViewControllerDelegate {
  func detailViewController(_ detailViewController: DetailViewController, didSelect favoriteButton: UIButton) {
    controller?.reloadDataAfterClickOnFavoriteButton()
  }
}

extension HomeDataSourceAndDelegate: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    controller?.homeViewModel.searchModels = []
    
    guard let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty else { return }
    
    for model in (controller?.homeViewModel.models ?? []) {
      if (model.game?.name.lowercased() ?? "").contains(searchText) {
        controller?.homeViewModel.searchModels?.append(model)
      }
    }
    
    controller?.searchEnable = searchController.searchBar.showsCancelButton
    controller?.collectionView.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    searchBar.text = nil
    searchBar.showsCancelButton = false
    searchBar.resignFirstResponder()
    
    controller?.collectionView.allowsSelection = true
    controller?.clearSearch()
    controller?.tabBarController?.hideTabBarAnimated(hide: false)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    controller?.collectionView.allowsSelection = true
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    controller?.clearSearch()
    controller?.collectionView.allowsSelection = false
    searchBar.showsCancelButton = true
    controller?.tabBarController?.hideTabBarAnimated(hide: true)
  }
}
