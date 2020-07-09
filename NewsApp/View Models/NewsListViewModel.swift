//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol NewsListViewModelDelegate: class {
    func parseNewsItemsSuccess()
    func parseNewsItemsFailureWithMessage(message: String)
}


class NewsListViewModel: NSObject {
    private var parserObj  = NewsParser()
    weak var delegate: NewsListViewModelDelegate!
    var subscriptions = [AnyCancellable]()

    private var newsItems: [News] {
        didSet {
            self.delegate?.parseNewsItemsSuccess()
        }
    }
    
    private var networkManager: NetworkManager?
    
    private var countryCode: String {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return countryCode
        }
        return "US"
    }
    
   
    
    init(delegate: NewsListViewModelDelegate?) {
        self.newsItems = [News]()
        self.delegate = delegate
        
    }
    
    // Downloads News Data and Parse the Response
    func downloadNewsData()
    {
        let urlEndPoint = UrlEndpoint.getNewsUrl(query: countryCode)
        let newsUrl = urlEndPoint.url
        networkManager = NetworkManager()
        networkManager?.downloadNews(url: newsUrl!)
                .sink(receiveCompletion: {completion in
                    switch(completion){
                    case .failure(let error):
                        self.delegate?.parseNewsItemsFailureWithMessage(message: error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
            }, receiveValue: {value in
                self.newsItems = value.articles
            })
        .store(in: &subscriptions)
    }
    
    
    
    
    /// Returns the number of news items
    /// - returns:  Count of News Items
    func numberOfNewsItems() -> Int {
        return self.newsItems.count
    }
    
    /// Returns the News View Model based on the the row index
    /// - parameter index: Index of the row to get the News View Model
    /// - returns:  News View Model
    func newsAtIndex(index: Int) -> NewsViewModel {
        return NewsViewModel(newsItem: self.newsItems[index], networkLayer:networkManager)
    }
    
}
