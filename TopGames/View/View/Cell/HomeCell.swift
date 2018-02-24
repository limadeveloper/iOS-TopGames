//
//  HomeCell.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var homeCellViewModel: HomeCellViewModel? {
        didSet {
            
            guard let homeCellViewModel = homeCellViewModel else { return }
            titleLabel.text = homeCellViewModel.getItemName()
            
            guard let image = homeCellViewModel.getItemImage(), let url = URL(string: image) else { return }
            imageView.af_setImage(withURL: url)
        }
    }
}
