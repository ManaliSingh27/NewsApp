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
    private let imageDownloader: ImageDownloader = ImageDownloader()
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
        return self.newsItem.publishedAt ?? ""
    }
    
    var newsUrl: String? {
        return self.newsItem.url
    }
    
    var newsImage: UIImage? {
        downloadNewsImages()
        return imageNews
    }
    
    private func downloadNewsImages() {
        guard (newsItem.urlToImage != nil) else{return }
        
        imageDownloader.downloadImage(photoUrl:newsItem.urlToImage! , completion: {
            (image) in
            self.imageNews = image
        })
    }
    
    
   
}
