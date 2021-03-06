//
//  FavoritesViewControllerSpec.swift
//  TopGamesTests
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Quick
import Nimble
@testable import TopGames

private let topGamesJsonFileName = "top_games"

class FavoritesViewControllerSpec: QuickSpec {
  override func spec() {
    describe("favorites view controller spec") {
      
      var controller: FavoritesViewController?
      var model: GameModel?
      let network = Network()
      
      beforeSuite {
        
        model = (network.fetchJSON(from: topGamesJsonFileName) as? [Any])?.toModels()?.last
        
        controller = StoryboardUtil.favoritesNavigationViewController()?.viewControllers.last as? FavoritesViewController
        controller?.loadViewIfNeeded()
        
        GameModel.delele()
        
        model?.isFavorite = true
        
        waitUntil { done in
          model?.recordGame { _ in
            done()
          }
        }
        
        controller?.viewWillAppear(false)
      }
      
      it("should have a valid controller") {
        expect(controller).toNot(beNil())
        expect(controller).to(beAnInstanceOf(FavoritesViewController.self))
      }
      
      it("should be able to get favorite games") {
        expect(controller?.homeViewModel.favoritesModels).toNot(beNil())
        expect(controller?.homeViewModel.favoritesModels?.count).to(beGreaterThan(Int()))
      }
      
      it("should have a navigation initialized") {
        
        expect(controller?.navigationItem.title).to(equal(LocalizedUtil.Text.favoritesNavigationTitle))
        expect(controller?.navigationItem.rightBarButtonItem).to(beNil())
        
        if #available(iOS 11.0, *) {
          expect(controller?.navigationItem.searchController).to(beNil())
        }
      }
      
      it("refresh control should be initialized") {
        expect(controller?.refreshControl.allTargets.count).to(beGreaterThan(Int()))
      }
      
      it("should have a background label about data") {
        expect(controller?.backgroundLabel).toNot(beNil())
        expect(controller?.backgroundLabel).to(beAnInstanceOf(UILabel.self))
        expect(controller?.backgroundLabel?.text).to(equal(LocalizedUtil.Text.errorNoData))
        expect(controller?.backgroundLabel?.font.fontName).to(equal(FontUtil.FontName.halo))
        expect(controller?.backgroundLabel.gestureRecognizers?.count).to(beGreaterThan(Int()))
        expect(controller?.backgroundLabel.gestureRecognizers?.last).to(beAnInstanceOf(UITapGestureRecognizer.self))
        expect(controller?.backgroundLabel.gestureRecognizers?.last).to(equal(controller?.tapGesture))
      }
      
      it("should have a initialized collection view") {
        expect(controller?.collectionView).toNot(beNil())
        expect(controller?.collectionView).to(beAnInstanceOf(UICollectionView.self))
        expect(controller?.collectionView.dataSource).to(beAnInstanceOf(FavoritesDataSourceAndDelegate.self))
        expect(controller?.collectionView.delegate).to(beAnInstanceOf(FavoritesDataSourceAndDelegate.self))
        expect(controller?.dataSourceAndDelegate?.collectionView(controller?.collectionView ?? UICollectionView(), numberOfItemsInSection: Int())).to(equal(1))
      }
    }
  }
}
