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
        static let limit = "limit"
    }
    
    struct KeyValue {
        static let top = "top"
        static let viewers = "viewers"
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
    ///   - limitValue: the number of results
    ///   - completion: handle for results
    func fetchTopGames(page: Int, limitValue: Int = 20, completion: (([Any]?, Error?) -> Void)?) {
        
        let url = URL(string: api + EndPoint.topGames.rawValue)!
        
        let parameters: Parameters = [
            ParameterKey.offset: page,
            ParameterKey.limit: limitValue
        ]
        
        let headers: HTTPHeaders = [
            Header.acceptKey: Header.acceptValue,
            Header.clientIdKey: Header.clientIdValue
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            
            let result = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: .allowFragments) as? [AnyHashable: Any]
            var topGames = result??[KeyValue.top] as? [Any]
            
            if let games = topGames as? [[String: Any]] {
                topGames = games.sorted { ($0[KeyValue.viewers] as? Int ?? 0) > ($1[KeyValue.viewers] as? Int ?? 0) }
            }
            
            completion?(topGames, response.error)
        }
    }
    
    /// Check network connection
    ///
    /// - Returns: a boolean value about internet connection
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    /// Fetch local JSON file
    ///
    /// - Parameter file: JSON file name
    /// - Returns: JSON collection data object result
    func fetchJSON(from file: String) -> Any? {
        guard let path = Bundle.main.path(forResource: file, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}
