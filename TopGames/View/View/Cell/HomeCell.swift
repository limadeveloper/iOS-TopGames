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
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private let kFavoriteButtonFontSize: CGFloat = 24
    
    weak var delegate: HomeCellDelegate?
    
    var homeCellViewModel: HomeCellViewModel? {
        didSet {
            
            titleLabel.text = homeCellViewModel?.getItemName()
            
            guard let image = homeCellViewModel?.getItemImage(), let url = URL(string: image) else { return }
            imageView.af_setImage(withURL: url)
        }
    }
    
    // MARK: - Actions
    @IBAction func markFavorite(sender: UIButton) {
        homeCellViewModel?.updateFavoriteModel { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.homeCell(strongSelf, didSelect: sender)
        }
    }
    
    private func setFavoriteButton(with status: Bool) {
        favoriteButton.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: kFavoriteButtonFontSize)
        favoriteButton.setTitle(String.fontAwesomeIcon(FontUtil.FontIcon.heart), for: .normal)
        favoriteButton.setTitleColor(ColorUtil.favorite(when: status), for: .normal)
    }
}
