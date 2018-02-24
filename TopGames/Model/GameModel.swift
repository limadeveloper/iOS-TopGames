//
//  GameModel.swift
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
    static let id = "id"
}

// MARK: - Model
class GameModel: Codable {
    
    var game: Game?
    var viewers: Int
    var channels: Int
    var isRecorded: Bool? = false
    
    struct Game: Codable {
        var name: String
        var popularity: Int
        var id: Int
        var giantbombId: Int
        var image: GameImage?
        var logo: GameLogo?
        var localizedName: String
        var locale: String
    }
    
    init?(entity: GameEntity) {
        game = Game(entity: entity)
        viewers = Int(entity.viewers)
        channels = Int(entity.channels)
        isRecorded = true
    }
}

extension GameModel.Game {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case popularity
        case id = "_id"
        case giantbombId = "giantbomb_id"
        case image = "box"
        case logo
        case localizedName = "localized_name"
        case locale
    }
    
    init?(entity: GameEntity) {
        name = entity.name ?? ""
        popularity = Int(entity.popularity)
        id = Int(entity.id)
        giantbombId = Int(entity.giantbombId)
        localizedName = entity.localizedName ?? ""
        locale = entity.locale ?? ""
        image = GameImage(entity: entity.image)
        logo = GameLogo(entity: entity.logo)
    }
}

// MARK: - Persistent Data
extension GameModel {
    
    private func record(completion: ((String?) -> Void)? = nil) {
        
        guard let entity = dataManager.getManagedObject(type: .game) as? GameEntity, let id = game?.id else {
            completion?(LocalizedUtil.Text.errorSaveData)
            return
        }
        
        entity.id = Int32(id)
        entity.name = game?.name
        entity.popularity = Int32(game?.popularity ?? 0)
        entity.giantbombId = Int32(game?.giantbombId ?? 0)
        entity.localizedName = game?.localizedName
        entity.locale = game?.locale
        entity.viewers = Int32(viewers)
        entity.channels = Int32(channels)
        
        dataManager.record(entity.managedObjectContext) { recordGameError in
            self.game?.image?.recordImage(with: id) { _ in
                self.game?.logo?.recordLogo(with: id) { _ in
                    self.isRecorded = true
                    completion?(recordGameError?.localizedDescription)
                }
            }
        }
    }
    
    private func update(_ entities: [GameEntity]) {
        for entity in entities {
            
            entity.name = game?.name
            entity.popularity = Int32(game?.popularity ?? 0)
            entity.giantbombId = Int32(game?.giantbombId ?? 0)
            entity.localizedName = game?.localizedName
            entity.locale = game?.locale
            entity.viewers = Int32(viewers)
            entity.channels = Int32(channels)
            
            dataManager.record(entity.managedObjectContext) { error in
                if error == nil, let gameId = self.game?.id {
                    self.game?.image?.recordImage(with: gameId)
                    self.game?.logo?.recordLogo(with: gameId)
                    self.isRecorded = true
                }
            }
        }
    }
    
    func recordGame(completion: ((String?) -> Void)? = nil) {
        
        let predicate = dataManager.predicate(id: game?.id, key: AttributeName.id, type: .equal)
        let fetchResult = dataManager.fetchResult(from: .game, predicate: predicate)
        
        func record() {
            self.record(completion: completion)
        }
        
        if fetchResult.items == nil {
            record()
        } else {
            if var entities = fetchResult.items as? [GameEntity], let id = game?.id {
                if predicate == nil {entities = entities.filter({ $0.id == id })}
                if entities.count > 0 {
                    self.update(entities)
                    completion?(nil)
                } else { record() }
            } else { record() }
        }
    }
    
    static func isDelete() -> Bool? {
        let isImageDeleted = dataManager.delete(entity: .image)
        let isLogoDeleted = dataManager.delete(entity: .logo)
        let isGameDeleted = dataManager.delete(entity: .game)
        let results = [isImageDeleted, isLogoDeleted, isGameDeleted]
        return results.map({ $0 != nil }).count > 0
    }
    
    static func delele() {
        _ = isDelete()
    }
    
    static func fetchResult(with paramValueNumber: (value: Int, key: String, type: DataManager.PredicateType)? = nil, paramValueText: (value: String, key: String, type: DataManager.PredicateType)? = nil) -> (games: [GameModel]?, error: String?) {
        
        var result: (games: [GameModel]?, error: String?) = (nil, LocalizedUtil.Text.errorDataNoFound)
        var resultItems = [GameModel]()
        var predicate: NSPredicate?
        
        if let paramValueNumber = paramValueNumber {
            predicate = dataManager.predicate(id: paramValueNumber.value, key: paramValueNumber.key, type: paramValueNumber.type)
        } else if let paramValueText = paramValueText {
            predicate = dataManager.predicate(value: paramValueText.value, key: paramValueText.key, type: paramValueText.type)
        }
        
        let fetchResult = dataManager.fetchResult(from: .game, predicate: predicate)
        
        if let entities = fetchResult.items as? [GameEntity], entities.count > 0 {
            
            for entity in entities {
                guard let item = GameModel(entity: entity) else { continue }
                resultItems.append(item)
            }
            
            if resultItems.count > 0 {
                result = (resultItems, nil)
            }
        }
        
        return result
    }
    
    static func fetchGameEntity(by id: Int) -> GameEntity? {
        let predicate = dataManager.predicate(id: id, key: AttributeName.id, type: .equal)
        let result = dataManager.fetchResult(from: .game, predicate: predicate).items?.last as? GameEntity
        return result
    }
    
    static func fetchGameModel(by id: Int) -> GameModel? {
        guard let entity = fetchGameEntity(by: id) else { return nil }
        return GameModel(entity: entity)
    }
}