//
//  APIClient.swift
//  TopGames
//
//  Created by John Lima on 23/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation
import Alamofire

struct APIClient {
    
    // MARK: - Properties
    private let api = "https://api.twitch.tv/kraken/"
    private let initialPage = 0
    
    // MARK: - Struct and Enums
    enum EndPoint: String {
        case topGames = "games/top?"
    }
    
    struct ParameterKey {
        static let offset = "offset"
        static let top = "top"
    }
    
    struct Header {
        static let acceptKey = "Accept"
        static let acceptValue = "application/vnd.twitchtv.v5+json"
        static let clientIdKey = "Client-ID"
        static let clientIdValue = "5f1mxwqmosk9lsmwoglmz7o6icahcq"
    }
    
    // MARK: - Actions
    /// Run this block to fetch top games
    ///
    ///     apiClient.fetchGames(page: pageIndex) { [weak self] (games, error) in
    ///         print(games)
    ///     }
    ///
    /// - Parameters:
    ///   - endPoint: end point using to fetch the games
    ///   - page: page number or offset
    ///   - completion: handle for results
    func fetchTopGames(page: Int, completion: (([Any]?, Error?) -> Void)?) {
        
        let url = URL(string: api + EndPoint.topGames.rawValue)!
        let parameters: Parameters = [ParameterKey.offset: page]
        
        let headers: HTTPHeaders = [
            Header.acceptKey: Header.acceptValue,
            Header.clientIdKey: Header.clientIdValue
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            let result = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments) as? [AnyHashable: Any]
            let topGames = result??[ParameterKey.top] as? [Any]
            completion?(topGames, response.error)
        }
    }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func fetchJSON(from file: String) -> Any? {
        guard let path = Bundle.main.path(forResource: file, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}
