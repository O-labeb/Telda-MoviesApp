//
//  MovieDetailsConfigurator.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

enum MovieDetailsConfigurator {
    static func configure(with movieID: Int) -> MovieDetailsViewController {
        let worker = MovieDetailsWorker()
        let viewController = MovieDetailsViewController()
        let presenter = MovieDetailsPresenter(
            view: viewController,
            worker: worker,
            dataStore: UserDefaultsStorage.self,
            movieID: movieID
        )
        viewController.presenter = presenter
        
        return viewController
    }
}
