//
//  Parser.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation

/*enum ParserResult<T> {
    case success(T)
    case error(String)
}*/

protocol ParseData {
    func parseResponse(data: Data, completion: @escaping(_ result: Result<Any, Error>) -> Void)
}

class Parser {
    var dataParserObj: ParseData
    
    init(dataParser: ParseData) {
        self.dataParserObj = dataParser
    }
    
    func parseResponse(data: Data, completion: @escaping(_ result: Result<Any, Error>) -> Void) {
        dataParserObj.parseResponse(data: data, completion: {(result) in
            completion(result)
        })
    }
}

final class NewsParser: ParseData {
    /// Parse the data and returns success or failure
    /// - parameter data: Response
    /// - parameter completion : completion handler
    func parseResponse(data: Data, completion: @escaping(_ result: Result<Any, Error>) -> Void) {
        do {
            let response = try JSONDecoder().decode(Articles.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
        
    }
}
