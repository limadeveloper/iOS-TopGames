//
//  TodayCollectionViewCell.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    
    private let kBorderWidth: CGFloat = 2
    private let kBorderColor: UIColor = #colorLiteral(red: 0.08311908692, green: 0.09585536271, blue: 0.1130141392, alpha: 1)
    
    var widgetCellViewModel: TodayCellViewModel? {
        didSet {
            
            guard let viewModel = widgetCellViewModel else { return }
            
            if let image = viewModel.getModelImage(), let url = URL(string: image) {
                Network.fetchData(from: url) { data, _, _ in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self, let data = data else { return }
                        strongSelf.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    // MARK: - Actions
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.borderWidth = strongSelf.kBorderWidth
            strongSelf.layer.borderColor = strongSelf.kBorderColor.cgColor
        }
    }
}
