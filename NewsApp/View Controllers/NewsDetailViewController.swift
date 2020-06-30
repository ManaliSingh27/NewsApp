//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
   
    @IBOutlet weak var openUrlButton: UIButton!
    var newsViewModel: NewsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsViewModel.delegate = self
        showNewsDetails()
        guard newsViewModel.newsUrl != nil else { return }
        openUrlButton.isHidden = false
    }

    private func showNewsDetails() {
        newsImageView.image = newsViewModel.newsImage
        titleLabel.text = newsViewModel.newsTitle
        authorLabel.text = newsViewModel.authorName
        contentLabel.text = newsViewModel.contentText
        descriptionLabel.text = newsViewModel.descriptionText
        dateLabel.text = newsViewModel.publishedDate
    }

    // Opens the url on browser
    @IBAction func openNewsUrl(_ sender: UIButton) {
        guard let url = URL(string: newsViewModel.newsUrl!) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - News Image Download Delegate
extension NewsDetailViewController: NewsImageDownloaded {
    func newsImageDownloaded(image: UIImage) {
        DispatchQueue.main.async {
            self.newsImageView.image = image
        }
    }
    
    
}
