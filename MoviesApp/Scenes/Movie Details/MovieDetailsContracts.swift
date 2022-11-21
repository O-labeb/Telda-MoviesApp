//
//  MovieDetailsContracts.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

protocol MovieDetailsDisplayLogic: AnyObject {
    func displayMovieDetails(_ viewModel: MovieDetailsScene.Section)
    func displaySimilarMovies(_ viewModel: MovieDetailsScene.Section)
    func displayMoviesActors(_ viewModel: MovieDetailsScene.Section)
    func displayMoviesDirectors(_ viewModel: MovieDetailsScene.Section)
    func displayRightItemButton(with title: String)
}

protocol MovieDetailsBusinessLogic {
    func viewDidLoad()
    func didTapRightItemBarButton()
}

protocol MovieDetailsWorkerType {
    func fetchMovieDetails(input: Input.MovieDetails, completion: @escaping ((Result<MovieDetails, NetworkError>) -> Void))
    func fetchSimilarMovies(input: Input.SimilarMovies, completion: @escaping ((Result<MoviesList, NetworkError>) -> Void))
    func fetchMovieCredits(input: Input.MovieCredits, completion: @escaping ((Result<MovieCredits, NetworkError>) -> Void))
}
