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
    lazy var activityIndicator = UIActivityIndicatorView()
     var listCoorinator: NewsListCoordinator?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        configureTableView()
        newsListViewModel = NewsListViewModel(delegate:self)
        showNews()
    }
    
    private func configureTableView() -> Void {
        let nib = UINib.init(nibName: UIConstants.kNewsCellXib, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: UIConstants.kNewsCellIdentifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    // Checks Internet connectivity and downloads News data
    private func showNews() {
        guard currentReachabilityStatus != .notReachable else {
            self.showAlert(title:ErrorConstants.kError, message: ErrorConstants.kNoInternetError)
            return
        }
        self.showActivityIndicatory(activityIndicator: activityIndicator)
        newsListViewModel.downloadNewsData()
    }
    
    // MARK: - Refresh Control
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        showNews()
        refreshControl.endRefreshing()
    }
}

// MARK: - Table view Data Source
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsListViewModel.numberOfNewsItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: UIConstants.kNewsCellIdentifier, for: indexPath) as! NewsCell
        let newsViewModel: NewsViewModel = self.newsListViewModel.newsAtIndex(index:indexPath.row)
        cell.configureCell(viewModel: newsViewModel)
        return cell
    }
    
}

// MARK: - Table view delegates
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listCoorinator = NewsListCoordinator(navigationController: navigationController!, viewModel:self.newsListViewModel.newsAtIndex(index:indexPath.row) )
        listCoorinator?.start()
    }
}

// MARK: - News View Model delegates
extension NewsListViewController: NewsListViewModelDelegate {
    func parseNewsItemsSuccess() {
        DispatchQueue.main.async {
            self.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.tableView.reloadData()
        }
    }
    
    func parseNewsItemsFailureWithMessage(message: String) {
        DispatchQueue.main.async {
            self.removeActivityIndicator(activityIndicator: self.activityIndicator)
            self.showAlert(title:ErrorConstants.kError, message: message)
        }
    }
    
    
}
