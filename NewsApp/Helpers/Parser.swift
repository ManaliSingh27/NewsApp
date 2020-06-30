//
//  Parser.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation

enum ParserResult<T> {
    case success(T)
    case error(String)
}

protocol ParseData {
    func parseJson(data: Data, completion: @escaping(_ result: ParserResult<Any>) -> Void)
}

class Parser {
    var dataParserObj: ParseData
    
    init(dataParser: ParseData) {
        self.dataParserObj = dataParser
    }
    
    func parseJson(data: Data, completion: @escaping(_ result: ParserResult<Any>) -> Void) {
        dataParserObj.parseJson(data: data, completion: {(result) in
            completion(result)
        })
    }
}

final class NewsParser: ParseData {
    
    func parseJson(data: Data, completion: @escaping(_ result: ParserResult<Any>) -> Void) {
        
        do {
            let response = try JSONDecoder().decode(Articles.self, from: data)
            completion(.success(response))
        } catch {
            completion(.error("Some error occured"))
            print(error)
        }
        
    }
}
