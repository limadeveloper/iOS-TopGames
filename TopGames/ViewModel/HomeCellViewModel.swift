//
//  HomeCellViewModel.swift
//  TopGames
//
//  Created by John Lima on 24/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class HomeCellViewModel: NSObject {
    
    // MARK: - Properties
    private var model: GameModel?
    
    // MARK: - LifeCycle
    init?(model: GameModel?) {
        self.model = model
    }
    
    // MARK: - Actions
    func getModelImage() -> String? {
        return model?.game?.image?.large
    }
    
    func getModelName() -> String? {
        return model?.game?.name
    }
    
    func getModelIsFavorite() -> Bool {
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
}
