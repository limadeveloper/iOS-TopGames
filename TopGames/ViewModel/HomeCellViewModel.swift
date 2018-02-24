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
    private var itemImage: String?
    private var itemName: String?
    
    // MARK: - LifeCycle
    init?(model: GameModel?) {
        itemName = model?.game?.name
        itemImage = model?.game?.image?.large
    }
    
    // MARK: - Actions
    func getItemImage() -> String? {
        return itemImage
    }
    
    func getItemName() -> String? {
        return itemName
    }
}
