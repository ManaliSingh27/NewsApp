//
//  NewsCellViewModel.swift
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

class NewsCellViewModel
{
    var newsImage : UIImage? = nil
    private let imageDownloader : ImageDownloader = ImageDownloader()
    weak var delegate : NewsImageDownloaded?

    init(news: News) {
        let url : String = news.urlToImage!
        imageDownloader.downloadImage(photoUrl:url , completion: {
            (image) in
            self.newsImage = image
            self.delegate?.newsImageDownloaded(image: image)
        })
    }
}
