//
//  Network.swift
//  Widget
//
//  Created by John Lima on 26/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Foundation

struct Network {
    
    struct APIClient {
        
        private static let api = "https://api.twitch.tv/kraken/"
        private static let numberOfMostViewers = 3
        private static let emptyValue = 3
        
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
        
        static func fetchMostViewersTopGames(page: Int, limitValue: Int = 20, completion: Completion.Results) {
            
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
                let topGames = result??[KeyValue.top] as? [Any]
                
                if let games = topGames as? [[String: Any]] {
                    let resultGames = games.sorted { ($0[KeyValue.viewers] as? Int ?? emptyValue) > ($1[KeyValue.viewers] as? Int ?? emptyValue) }
                    if resultGames.count > numberOfMostViewers {
                        var selectedMostViewers = [Any]()
                        for i in emptyValue ..< resultGames.count {
                            selectedMostViewers.append(resultGames[i])
                            if selectedMostViewers.count == numberOfMostViewers {
                                break
                            }
                        }
                    }
                }
                
                completion?(topGames, error)
                
            }.resume()
        }
    }
    
    static func fetchData(from url: URL, completion: @escaping Completion.DataFromURL) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
