//
//  ImageCache.swift
//  NewsApp
//
//  Created by Manali Mogre on 30/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit

struct ImageCache {
    static var cache = NSCache<NSString, UIImage>()
    static func saveImage(image: UIImage?, url: URL) {
        guard let img = image else {
            return
        }
        cache.setObject(img, forKey: url.absoluteString as NSString)
    }
    static func getImage(url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as NSString)
    }
}
