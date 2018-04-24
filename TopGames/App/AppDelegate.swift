//
//  AppDelegate.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private var dataManager = DataManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    dataManager.showDataPath()
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    dataManager.saveContext()
  }
}
