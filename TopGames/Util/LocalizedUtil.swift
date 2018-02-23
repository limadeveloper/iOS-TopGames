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
    }
}

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
