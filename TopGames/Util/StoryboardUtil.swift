//
//  StoryboardUtil.swift
//  TopGames
//
//  Created by John Lima on 24/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

struct StoryboardUtil {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    static func homeNavigationViewController() -> UINavigationController? {
        return main.instantiateViewController(withIdentifier: "HomeNavigationViewController") as? UINavigationController
    }
    
    static func favoritesNavigationViewController() -> UINavigationController? {
        return main.instantiateViewController(withIdentifier: "FavoritesNavigationViewController") as? UINavigationController
    }
    
    static func detailViewController() -> DetailViewController? {
        return main.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
    }
}
