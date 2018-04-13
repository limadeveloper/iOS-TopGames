//
//  TodayCellViewModel.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class TodayCellViewModel: NSObject {
    
    // MARK: - Properties
    private var model: TodayGameModel?
    
    // MARK: - LifeCycle
    init?(model: TodayGameModel?) {
        self.model = model
    }
    
    // MARK: - Actions
    func getModelImage() -> String? {
        return model?.game?.image?.medium
    }
}
