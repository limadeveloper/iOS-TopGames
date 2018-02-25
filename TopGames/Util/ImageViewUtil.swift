//
//  ImageViewUtil.swift
//  TopGames
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func addBlurEffect(style: UIBlurEffectStyle = .regular) {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        for view in self.subviews where view is UIVisualEffectView {
            view.removeFromSuperview()
        }
        
        self.addSubview(blurEffectView)
    }
}
