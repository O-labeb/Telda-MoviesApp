//
//  MoviesListConfigurator.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

enum MoviesListConfigurator {
    static func configure() -> MoviesListViewController {
        let worker = MoviesListWorker()
        let viewController = MoviesListViewController()
        let presenter = MoviesListPresenter(view: viewController, worker: worker, dataStore: UserDefaultsStorage.self)
        let router = MoviesListRouter(viewController: viewController, dataStore: presenter)
        viewController.presenter = presenter
        viewController.router = router
        
        return viewController
    }
}
