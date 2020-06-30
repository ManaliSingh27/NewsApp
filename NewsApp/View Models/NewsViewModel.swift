//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit

protocol NewsImageDownloaded : class
{
    func newsImageDownloaded(image : UIImage)
}

class NewsViewModel: NSObject {
    
    private var newsItem: News
    private var imageNews: UIImage? {
        didSet {
            self.delegate?.newsImageDownloaded(image: self.imageNews!)
        }
    }
    weak var delegate : NewsImageDownloaded?
    
    init(newsItem: News) {
        self.newsItem = newsItem
    }
    
    var newsTitle: String {
        return self.newsItem.title ?? ""
    }
    
    var authorName: String {
        return self.newsItem.author ?? ""
    }
    
    var descriptionText: String {
        return self.newsItem.description ?? ""
    }
    
    var contentText: String {
        return self.newsItem.content ?? ""
    }
    
    var publishedDate: String {
        return self.newsItem.publishedAt?.dateFormattedString ?? ""
    }
    
    var newsUrl: String? {
        return self.newsItem.url
    }
    
    var newsImage: UIImage? {
        downloadNewsImages()
        return imageNews
    }
    
    private func downloadNewsImages() {
        let networkManager = NetworkManager(session: URLSession.shared)
        guard let newsImageUrl = newsItem.urlToImage else {
            self.imageNews = UIImage(named: "NewsPlaceholder")
            return }
        let url = URL(string: newsImageUrl)
        guard url != nil else {return}
        guard  ImageCache.getImage(url: url!) == nil else {
            self.imageNews = ImageCache.getImage(url: url!)
            return
        }
        networkManager.downloadImageWithUrl(url: url!, completion: {
            (result) in
            switch(result)
            {
            case .Success(let image):
                self.imageNews = image
            case .Error:
                self.imageNews = UIImage(named: "NewsPlaceholder")
            }
        })
    }
}
