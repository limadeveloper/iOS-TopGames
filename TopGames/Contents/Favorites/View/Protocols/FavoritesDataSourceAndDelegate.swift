//
//  FavoritesDataSourceAndDelegate.swift
//  TopGames
//
//  Created by John Lima on 22/04/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

class FavoritesDataSourceAndDelegate: NSObject {
  
  // MARK: - Properties
  private var controller: FavoritesViewController?
  
  // MARK: - Initializers
  init(with target: FavoritesViewController) {
    controller = target
  }
}

// MARK: - Extensions
extension FavoritesDataSourceAndDelegate: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let data = controller?.homeViewModel.favoritesModels
    return (data ?? []).count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell: HomeCell = collectionView.dequeueReusableCell(for: indexPath)
    
    guard let data = controller?.homeViewModel.favoritesModels else { return cell }
    
    cell.homeCellViewModel = HomeCellViewModel(model: data[indexPath.item])
    cell.delegate = self
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let detailViewController = StoryboardUtil.detailViewController(), let data = controller?.homeViewModel.favoritesModels else { return }
    
    detailViewController.delegate = self
    detailViewController.detailViewModel = DetailViewModel(model: data[indexPath.item])
    
    controller?.navigationController?.pushViewController(detailViewController, animated: true)
  }
}

extension FavoritesDataSourceAndDelegate: HomeCellDelegate {
  func homeCell(_ homeCell: HomeCell, didSelect favoriteButton: UIButton) {
    controller?.reloadDataAfterClickOnFavoriteButton()
  }
}

extension FavoritesDataSourceAndDelegate: DetailViewControllerDelegate {
  func detailViewController(_ detailViewController: DetailViewController, didSelect favoriteButton: UIButton) {
    controller?.reloadDataAfterClickOnFavoriteButton()
  }
}
