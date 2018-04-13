//
//  TodayViewController.swift
//  Widget
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let cellName = "cell"
    private let collectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (width: CGFloat, height: CGFloat)) = (12, 12, (75, 95))
    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    private var todayViewModel = TodayViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(.newData)
    }
    
    // MARK: - Actions
    private func loadData() {
        todayViewModel.loadData { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    private func updateUI() {
        
        let layout = KTCenterFlowLayout()
        
        layout.minimumInteritemSpacing = collectionlayout.minInteritemSpacing
        layout.minimumLineSpacing = collectionlayout.minLineSpacing
        layout.sectionInset = sectionInsets
        
        layout.itemSize = CGSize(
            width: collectionlayout.size.width,
            height: collectionlayout.size.height
        )
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension TodayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayViewModel.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? TodayCollectionViewCell
        let data = todayViewModel.models
        
        cell?.widgetCellViewModel = TodayCellViewModel(model: data[indexPath.item])
        
        return cell ?? UICollectionViewCell()
    }
}
