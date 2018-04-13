//
//  TodayGameModel.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

struct TodayGameModel: Codable {
    
    let game: Game?
    let viewers: Int
    let channels: Int
    
    struct Game: Codable {
        
        let name: String
        let popularity: Int
        let id: Int
        let giantbombId: Int
        let image: GameImage?
        let logo: GameImage?
        let localizedName: String
        let locale: String
        
        struct GameImage: Codable {
            let large: String
            let medium: String
            let small: String
            let template: String
        }
        
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
    }
}

extension Data {
    func toModel() -> TodayGameModel? {
        return try? JSONDecoder().decode(TodayGameModel.self, from: self)
    }
}

extension Collection {
    
    func toModel() -> TodayGameModel? {
        guard let model = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted).toModel() else { return nil }
        return model
    }
    
    func toModels() -> [TodayGameModel]? {
        var result = [TodayGameModel]()
        for item in self {
            guard let model = try? JSONSerialization.data(withJSONObject: item, options: .prettyPrinted).toModel(), let obj = model else { continue }
            result.append(obj)
        }
        return result
    }
    
    func noDuplicates() -> [TodayGameModel]? {
        let models = (self as? [TodayGameModel] ?? [])
        var result = [TodayGameModel]()
        for model in models {
            let hasDuplicates = result.filter({ $0.game?.id == model.game?.id }).count > 0
            if !hasDuplicates {
                result.append(model)
            }
        }
        return result
    }
}
