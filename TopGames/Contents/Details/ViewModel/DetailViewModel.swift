//
//  DetailViewModel.swift
//  TopGames
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class DetailViewModel: NSObject {
  
  // MARK: - Properties
  private var model: GameModel?
  
  // MARK: - Initializers
  init(model: GameModel?) {
    self.model = model
  }
  
  // MARK: - Public Methods
  func getImage() -> String? {
    return model?.game?.image?.large
  }
  
  func getName() -> String? {
    return model?.game?.name
  }
  
  func getViewers() -> Int? {
    return model?.viewers
  }
  
  func getFavoriteStatus() -> Bool {
    return model?.isFavorite ?? false
  }
  
  func updateFavoriteModel(with value: Bool, completion: ((String?) -> Void)? = nil) {
    if value {
      model?.isFavorite = value
      model?.recordGame(completion: completion)
      return
    }
    let error = model?.deleteObjectData()
    completion?(error?.localizedDescription)
  }
  
  func getUpdatedModel() -> DetailViewModel {
    guard let gameId = model?.game?.id else { return self }
    model = GameModel.fetchGameModel(by: gameId)
    return self
  }
}
