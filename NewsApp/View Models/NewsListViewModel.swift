//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit

protocol NewsListViewModelDelegate: class {
    func parseNewsItemsSuccess()
    func parseNewsItemsFailureWithMessage(message: String)
}


class NewsListViewModel: NSObject {
    private var parserObj  = NewsParser()
    weak var delegate: NewsListViewModelDelegate?
    
    private var newsItems: [News] {
        didSet {
            self.delegate?.parseNewsItemsSuccess()
        }
    }
    
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
    
    
    func downloadNewsData()
    {
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(countryCode)"
        let newsUrl = URL(string: urlString)
        let config = URLSessionConfiguration.default

        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "X-Api-Key": NetworkConstants.API_KEY
        ]

        let urlSession = URLSession(configuration: config)
        let networkManager = NetworkManager(session: urlSession)
        networkManager.downloadData(url: newsUrl!, completion: {[weak self](result) in
            switch(result)
            {
            case .Success(let data):
                let parserManager = Parser(dataParser: self!.parserObj)
                parserManager.parseJson(data: data, completion: {[weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let newsResponse):
                        let article: Articles = newsResponse as! Articles
                        self.newsItems = article.articles
                    case .error(let error):
                        self.delegate?.parseNewsItemsFailureWithMessage(message: error)
                    }
                })
            case .Error(let error):
                self?.delegate?.parseNewsItemsFailureWithMessage(message: error)
            }
        })
    }
    
    
    func numberOfNewsItems() -> Int {
        return self.newsItems.count
    }
    
    
    func newsAtIndex(index: Int) -> NewsViewModel {
        return NewsViewModel(newsItem: self.newsItems[index])
    }
    
}
