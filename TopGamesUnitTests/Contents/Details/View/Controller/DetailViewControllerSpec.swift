//
//  DetailViewControllerSpec.swift
//  TopGamesTests
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Quick
import Nimble
@testable import TopGames

private let topGamesJsonFileName = "top_games"

class DetailViewControllerSpec: QuickSpec {
  override func spec() {
    describe("detail view controller spec") {
      
      var controller: DetailViewController?
      var models = [GameModel]()
      let network = Network()
      
      beforeSuite {
        
        models = (network.fetchJSON(from: topGamesJsonFileName) as? [Any])?.toModels() ?? []
        
        controller = StoryboardUtil.detailViewController()
        controller?.detailViewModel = DetailViewModel(model: models.first)
        controller?.loadViewIfNeeded()
      }
      
      it("should have the initialized controller") {
        expect(controller).toNot(beNil())
        expect(controller).to(beAnInstanceOf(DetailViewController.self))
      }
      
      it("should have a view model") {
        expect(controller?.detailViewModel).toNot(beNil())
        expect(controller?.detailViewModel).to(beAnInstanceOf(DetailViewModel.self))
      }
      
      it("should have a navigation initialized") {
        
        controller?.viewDidAppear(false)
        
        expect(controller?.navigationItem.title).to(equal(LocalizedUtil.Text.detailsNavigationTitle))
        expect(controller?.navigationItem.rightBarButtonItem).toNot(beNil())
        
        if #available(iOS 11.0, *) {
          expect(controller?.navigationItem.searchController).to(beNil())
        }
      }
      
      it("should have a blur background image") {
        expect(controller?.backgroundImageView).to(beAnInstanceOf(UIImageView.self))
        expect(controller?.backgroundImageView.subviews.map({ $0 is UIVisualEffectView }).count).to(equal(1))
      }
      
      it("should have a image view to show game image") {
        expect(controller?.imageView).toNot(beNil())
        expect(controller?.imageView).to(beAnInstanceOf(UIImageView.self))
      }
      
      it("should have a label to show the game name") {
        expect(controller?.nameLabel).toNot(beNil())
        expect(controller?.nameLabel).to(beAnInstanceOf(UILabel.self))
        expect(controller?.nameLabel.text).to(equal(controller?.detailViewModel?.getName()))
        expect(controller?.nameLabel.font.fontName).to(equal(FontUtil.FontName.halo))
      }
      
      it("should have a label to show the game viewers") {
        expect(controller?.viewersLabel).toNot(beNil())
        expect(controller?.viewersLabel).to(beAnInstanceOf(UILabel.self))
        expect(controller?.viewersLabel.text).to(equal(LocalizedUtil.Text.detailsViewersLabelText + String(controller?.detailViewModel?.getViewers() ?? Int())))
        expect(controller?.viewersLabel.font.fontName).to(equal(FontUtil.FontName.halo))
      }
    }
  }
}
