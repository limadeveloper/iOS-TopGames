//
//  WidgetViewController.swift
//  Widget
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import NotificationCenter
import KTCenterFlowLayout

class WidgetViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let cellName = "cell"
    private let collectionlayout: (minInteritemSpacing: CGFloat, minLineSpacing: CGFloat, size: (width: CGFloat, height: CGFloat)) = (1, 1, (50, 50))
    
    private var widgetViewModel: WidgetViewModel?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        updateUI()
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
        /*widgetViewModel?.loadData { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }*/
        let items = WidgetAPIClient().fetchJSON(from: "top_games") as? [[AnyHashable: Any]]
        for item in items ?? [] {
            guard let model = try? JSONSerialization.data(withJSONObject: item, options: .prettyPrinted).toModel(), let obj = model else { continue }
            widgetViewModel?.models.append(obj)
        }
        collectionView.reloadData()
    }
    
    private func updateUI() {
        
        let layout = KTCenterFlowLayout()
        
        layout.minimumInteritemSpacing = collectionlayout.minInteritemSpacing
        layout.minimumLineSpacing = collectionlayout.minLineSpacing
        
        layout.itemSize = CGSize(
            width: collectionlayout.size.width,
            height: collectionlayout.size.height
        )
        
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension WidgetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = widgetViewModel?.models
        return (data ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? WidgetCollectionViewCell
        
        guard let data = widgetViewModel?.models else { return cell ?? UICollectionViewCell() }
        cell?.widgetCellViewModel = WidgetCellViewModel(model: data[indexPath.item])
        
        return cell ?? UICollectionViewCell()
    }
}
