//
//  BaseCoordinator.swift
//  NewsApp
//
//  Created by Manali Mogre on 05/07/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
         let vc = NewsListViewController()
        navigationController.pushViewController(vc, animated: false)
    }
    
}

class NewsListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var newsViewModel: NewsViewModel
    
    init(navigationController: UINavigationController, viewModel: NewsViewModel) {
        self.navigationController = navigationController
        self.newsViewModel = viewModel
    }
    
    func start() {
        let vc = NewsDetailViewController(nibName: UIConstants.kNewsDetailViewsControllerXib, bundle: nil)
        vc.newsViewModel = self.newsViewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
