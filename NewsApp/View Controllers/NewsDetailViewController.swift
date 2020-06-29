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
   
    var newsViewModel: NewsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsViewModel.delegate = self
        showNewsDetails()
        // Do any additional setup after loading the view.
    }

    private func showNewsDetails() {
        newsImageView.image = newsViewModel.newsImage
        titleLabel.text = newsViewModel.newsTitle
        authorLabel.text = newsViewModel.authorName
        contentLabel.text = newsViewModel.contentText
        descriptionLabel.text = newsViewModel.descriptionText
        dateLabel.text = newsViewModel.publishedDate
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsDetailViewController: NewsImageDownloaded {
    func newsImageDownloaded(image: UIImage) {
        DispatchQueue.main.async {
            self.newsImageView.image = image
        }
    }
    
    
}
