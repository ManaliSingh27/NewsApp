//
//  ImageDownloader.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloadable
{
    func downloadImage(photoUrl : String, completion : @escaping (_ image : UIImage) -> Void)
}

struct ImageDownloader : ImageDownloadable
{
    
    func downloadImage(photoUrl : String, completion : @escaping (_ image : UIImage) -> Void)
    {
        let url = URL(string: photoUrl)
        let networkManager = NetworkManager(session: URLSession.shared)
        guard url != nil else
        {
            return
        }
        if let cachedImage = ImageCache.getImage(url: url!) {
            completion(cachedImage)
        }
        
        networkManager.downloadImageWithUrl(url: url!, completion: {
            (result) in
            switch(result)
            {
            case .Success(let image):
                completion(image)
            case .Error:
                print("placeholder image")
            }
        })
    }
}
