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
    
    
    // MARK: - Download Data
    
    // Downloads Data for the url passed as parameter
    /// - parameter url: url of image to be downloaded
    /// - parameter completion: completion handler
    public func downloadData(url : URL, completion : @escaping(_ result : Result<Data, CustomError>) -> Void)
    {
        
        let sessionDataTask = session.dataTask(with: url, completionHandler: {data, response, error
            in
            guard error == nil else {return completion(.failure(CustomError.downloadError))}
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200...299).contains(status) else {
                completion(.failure(CustomError.authenticationError))
                return
            }
            guard let data = data else {return completion(.failure(CustomError.downloadError))}
            completion(.success(data))
        })
        sessionDataTask.resume()
    }
    
    // MARK: - Download Image
    
    // Downloads Image for the url passed as parameter
    /// - parameter url: url of image to be downloaded
    /// - parameter completion: completion handler
    public func downloadImageWithUrl(url : URL, completion : @escaping (Result<UIImage, CustomError>) -> Void)
    {
        let sessionDataTask = session.dataTask(with:url , completionHandler: {
            data,response, error in
            guard error == nil else { return completion(.failure(CustomError.downloadError)) }
            guard let data = data else { return completion(.failure(CustomError.downloadError))
            }
            if let cachedImage = ImageCache.getImage(url: url) {
                completion(.success(cachedImage))
            } else {
                let image = UIImage.init(data: data)
                ImageCache.saveImage(image: image, url: url)
                completion(.success(image ?? UIImage(named: "NewsPlaceholder")!))
            }
        })
        sessionDataTask.resume()
    }
    
    public func cancelDownloadForTask(withURL url: URL) {
        (session as! URLSession).getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }.first?
                .cancel()
        }
    }
}
