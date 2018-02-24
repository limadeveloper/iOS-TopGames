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
    private var modelImage: String?
    private var modelName: String?
    private var modelId: Int?
    
    // MARK: - LifeCycle
    init?(model: GameModel?) {
        modelName = model?.game?.name
        modelImage = model?.game?.image?.large
        modelId = model?.game?.id
    }
    
    // MARK: - Actions
    func getItemImage() -> String? {
        return modelImage
    }
    
    func getItemName() -> String? {
        return modelName
    }
    
    func updateFavoriteModel(completion: (() -> Void)? = nil) {
        completion?()
    }
}
