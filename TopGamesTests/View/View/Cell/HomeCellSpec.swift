//
//  HomeCellSpec.swift
//  TopGamesTests
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Quick
import Nimble
@testable import TopGames

private let topGamesJsonFileName = "top_games"

class HomeCellSpec: QuickSpec {
    override func spec() {
        describe("home cell spec") {
            
            let apiClient = APIClient()
            var cell: HomeCell?
            var controller: HomeViewController?
            
            beforeEach {
                
                controller = StoryboardUtil.homeNavigationViewController()?.viewControllers.last as? HomeViewController
                controller?.loadViewIfNeeded()
                controller?.homeViewModel.models = (apiClient.fetchJSON(from: topGamesJsonFileName) as? [Any])?.toModels() ?? []
                controller?.collectionView.reloadData()
                
                guard let controller = controller else { return }
                
                let indexPath = IndexPath(item: 0, section: 0)
                cell = controller.collectionView(controller.collectionView, cellForItemAt: indexPath) as? HomeCell
                cell?.homeCellViewModel = HomeCellViewModel(model: controller.homeViewModel.models?[indexPath.item])
            }
            
            it("should have a initialized cell") {
                expect(cell).toNot(beNil())
                expect(cell).to(beAnInstanceOf(HomeCell.self))
            }
            
            it("should have a view model") {
                expect(cell?.homeCellViewModel).toNot(beNil())
                expect(cell?.homeCellViewModel).to(beAnInstanceOf(HomeCellViewModel.self))
            }
            
            it("should have a image view to show game image") {
                expect(cell?.imageView).toNot(beNil())
                expect(cell?.imageView).to(beAnInstanceOf(UIImageView.self))
                expect(cell?.imageView.contentMode).to(equal(.scaleAspectFill))
            }
            
            it("should have a label to game name") {
                expect(cell?.titleLabel).toNot(beNil())
                expect(cell?.titleLabel).to(beAnInstanceOf(UILabel.self))
                expect(cell?.titleLabel.text).to(equal(cell?.homeCellViewModel?.getModelName()))
                expect(cell?.titleLabel.font.fontName).to(equal(FontUtil.FontName.halo))
            }
        }
    }
}
