//
//  GameImage.swift
//  TopGames
//
//  Created by John Lima on 23/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation
import CoreData

private var dataManager = DataManager()

// MARK: - Attributes
private struct AttributeName {
  static let id = "game.id"
}

// MARK: - Model
struct GameImage: Codable {
  
  var large: String
  var medium: String
  var small: String
  var template: String
  
  init?(entity: ImageEntity?) {
    large = entity?.large ?? ""
    medium = entity?.medium ?? ""
    small = entity?.small ?? ""
    template = entity?.template ?? ""
  }
}

// MARK: - Persistent Data
extension GameImage {
  
  private func record(with game: GameEntity, completion: ((String?) -> Void)? = nil) {
    
    guard let entity = dataManager.getManagedObject(type: .image) as? ImageEntity else { completion?(LocalizedUtil.Text.errorSaveData); return }
    
    entity.large = large
    entity.medium = medium
    entity.small = small
    entity.template = template
    entity.game = game
    
    dataManager.record(entity.managedObjectContext) { error in
      completion?(error?.localizedDescription)
    }
  }
  
  private func update(_ entities: [ImageEntity]) {
    for entity in entities {
      
      entity.large = large
      entity.medium = medium
      entity.small = small
      entity.template = template
      
      dataManager.record(entity.managedObjectContext)
    }
  }
  
  func recordImage(with gameId: Int, completion: ((String?) -> Void)? = nil) {
    
    let predicate = dataManager.predicate(id: gameId, key: AttributeName.id, type: .equal)
    let fetchResult = dataManager.fetchResult(from: .image, predicate: predicate)
    
    func record() {
      guard let game = (dataManager.fetchResult(from: .game).items as? [GameEntity])?.filter({ $0.id == Int32(gameId) }).last else { return }
      self.record(with: game, completion: completion)
    }
    
    if fetchResult.items == nil {
      record()
    } else {
      if var entities = fetchResult.items as? [ImageEntity], gameId > Int() {
        if predicate == nil {entities = entities.filter({ $0.game?.id == Int32(gameId) })}
        if entities.count > Int() {
          self.update(entities)
          completion?(nil)
        } else { record() }
      } else { record() }
    }
  }
  
  static func delete() -> Error? {
    return dataManager.delete(entity: .image)
  }
}
