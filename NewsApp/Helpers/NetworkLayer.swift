//
//  NetworkLayer.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit

enum APIResult<T>
{
    case Success(T)
    case Error(String)
}
enum ImageResult<T>
{
    case Success(UIImage)
    case Error
}

protocol URLSessionProtocol
{
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol
{
    func resume()
}


class NetworkManager {
    
    private let session : URLSessionProtocol
    let imageCache = NSCache<NSString, UIImage>()
    
    init(session : URLSessionProtocol) {
        self.session = session
    }
    
    // MARK: - Download Data
       
       // Downloads Data for the url passed as parameter
       /// - parameter url: url of image to be downloaded
       /// - parameter completion: completion handler
    public func downloadData(url : URL, completion : @escaping(_ result : APIResult<Data>) -> Void)
    {
        let sessionDataTask = session.dataTask(with: url, completionHandler: {data, response, error
            in
            guard error == nil else {return completion(.Error(error?.localizedDescription ?? "There is some issue in response"))}
            guard let data = data else {return completion(.Error(error?.localizedDescription ?? "There is no data to show"))}
            completion(.Success(data))
        })
        sessionDataTask.resume()
    }
    
    // MARK: - Download Image
    
    // Downloads Image for the url passed as parameter
    /// - parameter url: url of image to be downloaded
    /// - parameter completion: completion handler
    public func downloadImageWithUrl(url : URL, completion : @escaping (ImageResult<[AnyObject]>) -> Void)
    {
        let sessionDataTask   = session.dataTask(with:url , completionHandler: {[weak self]
            data,response, error in
            guard error == nil else { return completion(.Error) }
            guard let data = data else { return completion(.Error)
            }
            if let cachedImage = ImageCache.getImage(url: url) {
                completion(.Success(cachedImage))
            } else {
                let image = UIImage.init(data: data)
                ImageCache.saveImage(image: image, url: url)
                completion(.Success(image!))
            }
            
        })
        sessionDataTask.resume()
    }
    
}


class MockURLSession: URLSessionProtocol {
    private (set) var lastUrl : URL!
    var nextDataTask = MockURLSessionDataTask()
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastUrl = url
        return nextDataTask
    }
}



extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task  = dataTask(with: url, completionHandler: (completionHandler)) as URLSessionDataTask
        return task
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}



class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}



