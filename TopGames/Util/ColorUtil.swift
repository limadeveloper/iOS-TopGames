//
//  ColorUtil.swift
//  TopGames
//
//  Created by John Lima on 24/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

struct ColorUtil {
    
    static let navigationTint = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
    static let lightGray = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    
    /// Gets favorite color
    ///
    /// - Parameter value: status value about favorite
    /// - Returns: color for favorite button based in the status value
    static func favorite(when value: Bool) -> UIColor {
        return value ? #colorLiteral(red: 0.9254901961, green: 0.1529411765, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
