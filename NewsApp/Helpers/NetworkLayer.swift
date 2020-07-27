//
//  NetworkLayer.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit
import Combine


enum CustomError: String, Error {
    case authenticationError
    case downloadError
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authenticationError:
            return "There seems to be some problem. Please try again later"
        case .downloadError:
            return "Download Failed. Please try again later"
        }
    }
}



class NetworkManager {
    
    // private var session: URLSession = URLSession.shared
    
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "X-Api-Key": NetworkConstants.API_KEY
        ]
        return URLSession(configuration: config)
    }
    
    
    public func downloadNews(url:URL) -> AnyPublisher<Articles, Error>{

        var dataPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
        dataPublisher = session
            .dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
        return dataPublisher
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw CustomError.downloadError
                }
                return output.data
        }
        .retry(3)
        .decode(type: Articles.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
    }
    

    public func downloadImageWithUrl(url: URL) -> AnyPublisher<UIImage,Never> {
        var dataPublisher: AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
        dataPublisher = session
            .dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
        return dataPublisher
            .map{(UIImage.init(data: $0.data) ?? UIImage(named: "NewsPlaceholder")!)}
            .replaceError(with: UIImage(named: "NewsPlaceholder")!)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    public func cancelDownloadForTask(withURL url: URL) {
        session.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }.first?
                .cancel()
        }
    }
}
