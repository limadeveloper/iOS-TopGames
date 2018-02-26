//
//  WidgetCellViewModel.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

class WidgetCellViewModel: NSObject {
    
    // MARK: - Properties
    private var model: WidgetGameModel?
    
    // MARK: - LifeCycle
    init?(model: WidgetGameModel?) {
        self.model = model
    }
    
    // MARK: - Actions
    func getModelImage() -> String? {
        return model?.game?.image?.small
    }
    
    func getModelName() -> String? {
        return model?.game?.name
    }
}
