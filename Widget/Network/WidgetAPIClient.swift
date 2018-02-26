//
//  WidgetAPIClient.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

struct WidgetAPIClient {
    
    // MARK: - Properties
    private let api = "https://api.twitch.tv/kraken/"
    
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
    
    func fetchTopGames(page: Int, limitValue: Int = 20, completion: (([Any]?, Error?) -> Void)?) {
        
        let url = URL(string: api + EndPoint.topGames.rawValue)!
        
        let parameters = [
            ParameterKey.offset: page,
            ParameterKey.limit: limitValue
        ]
        
        let headers = [
            Header.acceptKey: Header.acceptValue,
            Header.clientIdKey: Header.clientIdValue
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        urlRequest.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            
            guard let data = data, error == nil else { completion?(nil, error); return }
            
            let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable: Any]
            var topGames = result??[KeyValue.top] as? [Any]
            
            if let games = topGames as? [[String: Any]] {
                topGames = games.sorted { ($0[KeyValue.viewers] as? Int ?? 0) > ($1[KeyValue.viewers] as? Int ?? 0) }
            }
            
            completion?(topGames, error)
            
        }.resume()
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
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
