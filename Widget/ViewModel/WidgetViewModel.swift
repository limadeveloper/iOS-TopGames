//
//  WidgetViewModel.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class WidgetViewModel: NSObject {
    
    // MARK: Properties
    var models = [WidgetGameModel]()
    let apiClient = WidgetAPIClient()
    
    private let emptyValue = 0
    private let limitValueOfGames = 100
    
    // MARK: Actions
    func loadData(with pageIndex: Int = 0, completion: (() -> Void)?) {
        
        /*apiClient.fetchTopGames(page: pageIndex, limitValue: limitValueOfGames) { (json, _) in
            if let json = json, let models = json.toModels(), models.count > self.emptyValue {
                self.models?.append(contentsOf: models)
                self.models = self.models?.noDuplicates()
            }
            completion?()
        }*/
        
        self.models = (apiClient.fetchJSON(from: "top_games") as? [Any])?.toModels() ?? []
        completion?()
    }
}
