//
//  ViewUtil.swift
//  TopGames
//
//  Created by John Lima on 25/04/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

protocol ReusableView: class {
  static var defaultReuseIdentifier: String { get }
}

protocol NIBLoadableView: class {
  static var nibName: String { get }
}

extension ReusableView where Self: UIView {
  static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}

extension NIBLoadableView where Self: UIView {
  static var nibName: String {
    return String(describing: self)
  }
}
