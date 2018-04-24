//
//  DetailViewController.swift
//  TopGames
//
//  Created by John Lima on 22/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

protocol DetailViewControllerDelegate: class {
  func detailViewController(_ detailViewController: DetailViewController, didSelect favoriteButton: UIButton)
}

class DetailViewController: UIViewController {
  
  // MARK: - Constants
  private let kFavoriteButtonRect = CGRect(x: 0, y: 0, width: 25, height: 25)
  private let kFavoriteButtonFontSize: CGFloat = 25
  
  // MARK: - Properties
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var viewersLabel: UILabel!
  
  private var favoriteButtonItem = UIBarButtonItem()
  
  var detailViewModel: DetailViewModel?
  weak var delegate: DetailViewControllerDelegate?
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setNavigation()
    setTabBar(hide: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    setTabBar(hide: false)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Private Methods
  private func updateUI() {
    
    nameLabel.text = detailViewModel?.getName()
    viewersLabel.text = LocalizedUtil.Text.detailsViewersLabelText + String(detailViewModel?.getViewers() ?? 0)
    
    guard let image = detailViewModel?.getImage(), let url = URL(string: image) else { return }
    
    backgroundImageView.af_setImage(withURL: url)
    backgroundImageView.addBlurEffect()
    
    imageView.af_setImage(withURL: url)
  }
  
  private func setNavigation() {
    setFavoriteButton()
    navigationItem.title = LocalizedUtil.Text.detailsNavigationTitle
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  private func setTabBar(hide: Bool) {
    tabBarController?.hideTabBarAnimated(hide: hide)
  }
  
  private func setFavoriteButton() {
    
    let favoriteStatus = detailViewModel?.getFavoriteStatus() ?? false
    
    let button = UIButton(frame: kFavoriteButtonRect)
    button.titleLabel?.font = UIFont.icon(from: .FontAwesome, ofSize: kFavoriteButtonFontSize)
    button.setTitle(String.fontAwesomeIcon(FontUtil.FontIcon.FontAwesome.heart), for: .normal)
    button.setTitleColor(ColorUtil.favorite(when: favoriteStatus), for: .normal)
    button.addTarget(self, action: #selector(markFavorite(sender:)), for: .touchUpInside)
    
    favoriteButtonItem = UIBarButtonItem(customView: button)
    
    navigationItem.rightBarButtonItem = favoriteButtonItem
  }
  
  @objc private func markFavorite(sender: UIButton) {
    let value = detailViewModel?.getFavoriteStatus() == true ? false : true
    detailViewModel?.updateFavoriteModel(with: value) { [weak self] error in
      guard let strongSelf = self else { return }
      strongSelf.delegate?.detailViewController(strongSelf, didSelect: sender)
      if error == nil {
        strongSelf.detailViewModel = strongSelf.detailViewModel?.getUpdatedModel()
        strongSelf.setFavoriteButton()
      }
    }
  }
}
