//
//  HomeViewControllerSpec.swift
//  TopGamesTests
//
//  Created by John Lima on 25/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Quick
import Nimble
@testable import TopGames

private let topGamesJsonFileName = "top_games"

class HomeViewControllerSpec: QuickSpec {
    override func spec() {
        describe("home view controller spec") {
            
            var controller: HomeViewController?
            let apiClient = APIClient()
            
            beforeSuite {
                controller = StoryboardUtil.homeNavigationViewController()?.viewControllers.last as? HomeViewController
                controller?.loadViewIfNeeded()
                controller?.homeViewModel.models = (apiClient.fetchJSON(from: topGamesJsonFileName) as? [Any])?.toModels() ?? []
                controller?.collectionView.reloadData()
            }
            
            it("should have the initialized controller") {
                
                expect(controller).toNot(beNil())
                expect(controller).to(beAnInstanceOf(HomeViewController.self))
                expect(controller?.navigationItem.title).to(equal(LocalizedUtil.Text.homeNavigationTitle))
                expect(controller?.navigationItem.rightBarButtonItem).toNot(beNil())
                
                if #available(iOS 11.0, *) {
                    expect(controller?.navigationItem.searchController).toNot(beNil())
                }
            }
            
            it("refresh control should be initialized") {
                expect(controller?.refreshControl.allTargets.count).to(beGreaterThan(0))
            }
            
            it("should have a background label about no internet connection") {
                expect(controller?.backgroundLabel).toNot(beNil())
                expect(controller?.backgroundLabel).to(beAnInstanceOf(UILabel.self))
                expect(controller?.backgroundLabel?.text).to(equal(LocalizedUtil.Text.errorNoConnection))
                expect(controller?.backgroundLabel?.font.fontName).to(equal(FontUtil.FontName.halo))
                expect(controller?.backgroundLabel.gestureRecognizers?.count).to(beGreaterThan(0))
                expect(controller?.backgroundLabel.gestureRecognizers?.last).to(beAnInstanceOf(UITapGestureRecognizer.self))
                expect(controller?.backgroundLabel.gestureRecognizers?.last).to(equal(controller?.tapGesture))
            }
            
            it("should have a view model") {
                expect(controller?.homeViewModel).toNot(beNil())
                expect(controller?.homeViewModel).to(beAnInstanceOf(HomeViewModel.self))
                expect(controller?.homeViewModel.apiClient).to(beAnInstanceOf(APIClient.self))
                expect(controller?.homeViewModel.alpha.min).to(equal((0)))
                expect(controller?.homeViewModel.alpha.max).to(equal((1)))
                expect(controller?.homeViewModel.models).to(beAnInstanceOf([GameModel].self))
                expect(controller?.homeViewModel.models?.count).to(beGreaterThan(0))
            }
            
            it("should have a initialized collection view") {
                expect(controller?.collectionView).toNot(beNil())
                expect(controller?.collectionView).to(beAnInstanceOf(UICollectionView.self))
                expect(controller?.collectionView.dataSource).to(beAnInstanceOf(HomeViewController.self))
                expect(controller?.collectionView.delegate).to(beAnInstanceOf(HomeViewController.self))
                expect(controller?.collectionView.numberOfItems(inSection: 0)).to(equal(10))
                expect(controller?.collectionlayout.minInteritemSpacing).to(equal(1))
                expect(controller?.collectionlayout.minLineSpacing).to(equal(1))
                expect(controller?.collectionlayout.size.percentWidth).to(equal(0.33))
                expect(controller?.collectionlayout.size.percentHeight).to(equal(0.3))
                expect(controller?.cellName).to(equal("HomeCell"))
            }
            
            it("sould have the search controller initialized") {
                expect(controller?.searchController).toNot(beNil())
                expect(controller?.searchController).to(beAnInstanceOf(UISearchController.self))
                expect(controller?.searchController?.searchResultsUpdater).to(beAnInstanceOf(HomeViewController.self))
                expect(controller?.searchController?.delegate).to(beAnInstanceOf(HomeViewController.self))
                expect(controller?.searchController?.dimsBackgroundDuringPresentation).to(equal(false))
                expect(controller?.searchController?.searchBar.barStyle).to(equal(.black))
                expect(controller?.searchController?.searchBar.delegate).to(beAnInstanceOf(HomeViewController.self))
            }
        }
    }
}
