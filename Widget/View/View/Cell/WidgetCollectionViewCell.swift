//
//  WidgetCollectionViewCell.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

class WidgetCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var widgetCellViewModel: WidgetCellViewModel? {
        didSet {
            
            guard let viewModel = widgetCellViewModel else { return }
            
            titleLabel.text = viewModel.getModelName()
            
            if let image = viewModel.getModelImage(), let url = URL(string: image) {
                WidgetAPIClient.getDataFromUrl(url: url) { [weak self] data, _, _ in
                    guard let strongSelf = self, let data = data else { return }
                    strongSelf.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}
