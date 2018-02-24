//
//  LocalizedUtil.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

struct LocalizedUtil {
    
    struct Text {
        static let homeNavigationTitle = "home.navigation.title".localized()
        static let favoritesNavigationTitle = "favorites.navigation.title".localized()
        static let detailsViewersLabelText = "details.viewersLabel.text".localized()
        static let errorSaveData = "error.save.data".localized()
        static let errorDataNoFound = "error.data.noFound".localized()
        static let errorNoConnection = "error.noConnection".localized()
    }
}

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
