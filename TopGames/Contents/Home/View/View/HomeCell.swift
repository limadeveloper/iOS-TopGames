//
//  HomeCell.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage
import SwiftIconFont

protocol HomeCellDelegate: class {
  func homeCell(_ homeCell: HomeCell, didSelect favoriteButton: UIButton)
}

class HomeCell: UICollectionViewCell {
  
  // MARK: - Constants
  private let kFavoriteButtonFontSize: CGFloat = 24
  private let kIsFavoriteButtonTag: Int = 1
  private let kIsNotFavoriteButtonTag = Int()
  
  // MARK: - Properties
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  weak var delegate: HomeCellDelegate?
  
  var homeCellViewModel: HomeCellViewModel? {
    didSet {
      
      guard let viewModel = homeCellViewModel else { return }
      
      titleLabel.text = viewModel.getModelName()
      setFavoriteButton(with: viewModel.getModelIsFavorite())
      
      if let image = viewModel.getModelImage(), let url = URL(string: image) {
        imageView.af_setImage(withURL: url)
      }
    }
  }
  
  // MARK: - Actions
  @IBAction func markFavorite(sender: UIButton) {
    let value = favoriteButton.tag == kIsNotFavoriteButtonTag ? true : false
    homeCellViewModel?.updateFavoriteModel(with: value) { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.delegate?.homeCell(strongSelf, didSelect: sender)
    }
  }
  
  // MARK: - Private Methods
  private func setFavoriteButton(with status: Bool) {
    favoriteButton.tag = status ? kIsFavoriteButtonTag : kIsNotFavoriteButtonTag
    favoriteButton.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: kFavoriteButtonFontSize)
    favoriteButton.setTitle(String.fontAwesomeIcon(FontUtil.FontIcon.FontAwesome.heart), for: .normal)
    favoriteButton.setTitleColor(ColorUtil.favorite(when: status), for: .normal)
  }
}
