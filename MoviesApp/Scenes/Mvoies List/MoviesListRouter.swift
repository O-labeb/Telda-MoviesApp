//
//  MoviesListRouter.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

final class MoviesListRouter {
    // MARK: - Stored properties
    unowned let viewController: UIViewController
    let dataStore: MoviesListDataStore
    
    internal init(viewController: UIViewController, dataStore: MoviesListDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
}

extension MoviesListRouter: MoviesListRoutingLogic {
    func routeToMovieDetails(at index: IndexPath) {
        let movie = dataStore.groupedMovies[index.section].movies[index.row]
        
        print(movie.title)
    }
}
