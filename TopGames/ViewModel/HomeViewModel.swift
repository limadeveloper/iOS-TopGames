//
//  HomeViewModel.swift
//  TopGames
//
//  Created by John Lima on 24/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    
    // MARK: Properties
    private let pageIndexIncrement = 1
    private let emptyValue = 0
    
    let apiClient = Network()
    let alpha: (min: Float, max: Float) = (0, 1)
    var models: [GameModel]?
    var searchModels: [GameModel]?
    var favoritesModels: [GameModel]?
    var collectionAlpha: Float = 0
    var pageIndex = 0
    
    // MARK: Actions
    
    /// Run this block to load more data
    ///
    /// - Parameters:
    ///   - pageIndex: api page index
    ///   - completion: handle for results that contains a boolean value about reload list of items
    func loadData(with pageIndex: Int = 0, completion: (() -> Void)?) {
        
        if models == nil || pageIndex == emptyValue {
            models = [GameModel]()
        }
        
        func connected(with json: [Any]?) {
            self.collectionAlpha = self.alpha.max
            if let json = json, let models = json.toModels(), models.count > self.emptyValue {
                self.models?.append(contentsOf: models)
                self.models = self.models?.noDuplicates()
                self.pageIndex += self.pageIndexIncrement
            }
            completion?()
        }
        
        func noConnected() {
            self.collectionAlpha = (self.models ?? []).count > self.emptyValue ? self.alpha.max : self.alpha.min
            completion?()
        }
        
        if self.apiClient.isConnectedToInternet() {
            apiClient.fetchTopGames(page: pageIndex) { (json, _) in
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
