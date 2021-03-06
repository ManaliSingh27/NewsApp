//
//  NewsCell.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell, NewsImageDownloaded {
   
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var newsViewModel: NewsViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(viewModel: NewsViewModel) {
        newsViewModel = viewModel
        viewModel.delegate = self
        self.titleLabel.text = viewModel.newsTitle
        self.newsImageView.image = nil
        self.newsImageView.image = viewModel.newsImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        newsViewModel!.cancelImageDownloadTasks()
        // cancel image download
    }
    
    func newsImageDownloaded(image: UIImage) {
        DispatchQueue.main.async {
            self.newsImageView.image = image
        }
    }
    
}
