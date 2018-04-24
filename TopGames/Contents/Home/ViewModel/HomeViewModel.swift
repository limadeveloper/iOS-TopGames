//
//  HomeViewModel.swift
//  TopGames
//
//  Created by John Lima on 24/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
  
  // MARK: Constants
  private let pageIndexIncrement = 1
  
  // MARK: Properties
  let network = Network()
  let alpha: (min: Float, max: Float) = (Float(), 1)
  var models: [GameModel]?
  var searchModels: [GameModel]?
  var favoritesModels: [GameModel]?
  var collectionAlpha = Float()
  var pageIndex = Int()
  
  // MARK: Public Methods
  
  /// Run this block to load more data
  ///
  /// - Parameters:
  ///   - pageIndex: api page index
  ///   - completion: handle for results that contains a boolean value about reload list of items
  func loadData(with pageIndex: Int = Int(), completion: (() -> Void)?) {
    
    if models == nil || pageIndex == Int() {
      models = [GameModel]()
    }
    
    func connected(with json: [Any]?) {
      self.collectionAlpha = self.alpha.max
      if let json = json, let models = json.toModels(), models.count > Int() {
        self.models?.append(contentsOf: models)
        self.models = self.models?.noDuplicates()
        self.pageIndex += self.pageIndexIncrement
      }
      completion?()
    }
    
    func noConnected() {
      self.collectionAlpha = (self.models ?? []).count > Int() ? self.alpha.max : self.alpha.min
      completion?()
    }
    
    if self.network.isConnectedToInternet() {
      network.fetchTopGames(page: pageIndex) { (json, _) in
        connected(with: json)
      }
    } else {
      noConnected()
    }
  }
  
  func loadFavoriteGames() {
    favoritesModels = GameModel.fetchResult().games?.filter({ $0.isFavorite ?? false })
  }
}
