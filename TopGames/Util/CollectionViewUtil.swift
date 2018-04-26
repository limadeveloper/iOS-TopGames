//
//  CollectionViewUtil.swift
//  TopGames
//
//  Created by John Lima on 25/04/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

private let kErrorDequeueCellIdenfier = "Could not dequeue cell with identifier"

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
    register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NIBLoadableView {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      fatalError("\(kErrorDequeueCellIdenfier): \(T.defaultReuseIdentifier)")
    }
    return cell
  }
}
