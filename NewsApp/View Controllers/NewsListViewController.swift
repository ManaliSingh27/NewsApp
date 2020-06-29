//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by Manali Mogre on 29/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var newsListViewModel: NewsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        newsListViewModel = NewsListViewModel(delegate:self)
        newsListViewModel.downloadNewsData()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() -> Void {
        let nib = UINib.init(nibName: "NewsCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "newsCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
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

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsListViewModel.numberOfNewsItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        let newsViewModel: NewsViewModel = self.newsListViewModel.newsAtIndex(index:indexPath.row)
        cell.configureCell(viewModel: newsViewModel)
        return cell
    }
    
}

extension NewsListViewController: NewsListViewModelDelegate {
    func parseNewsItemsSuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func parseNewsItemsFailureWithMessage(message: String) {
        
    }
    
    
}
