//
//  MoviesListContracts.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

protocol MoviesListDisplayLogic: AnyObject {
    func displayMoviesList(_ viewState: MoviesListScene.SceneState)
    func appendToMoviesList(_ viewState: MoviesListScene.SceneState)
    func displayError(_ viewState: MoviesListScene.SceneState)
    func displayNoResults(_ viewState: MoviesListScene.SceneState)
    func swapMovie(_ movie: MovieTableViewCell.ViewModel, at indexPath: IndexPath)
}

protocol MoviesListBusinessLogic {
    func fetchPopularMovies()
    func searchMoviesFor(query: String)
    func fetchMoreMovies()
}

protocol MoviesListWorkerType {
    func fetchPopularMovies(input: Input.PopularMovies, completion: @escaping ((Result<MoviesList, NetworkError>) -> Void))
    func searchMoviesList(input: Input.SearchMovies, completion: @escaping ((Result<MoviesList, NetworkError>) -> Void))
}

protocol MoviesListDataStore: AnyObject {
    var groupedMovies: [MoviesListScene.GroupedMovies] { get }
}

protocol MoviesListRoutingLogic: AnyObject {
    func routeToMovieDetails(at index: IndexPath)
}
