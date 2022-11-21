//
//  MovieDetailsWorker.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation
import Alamofire

class MovieDetailsWorker: MovieDetailsWorkerType {
    func fetchMovieDetails(input: Input.MovieDetails, completion: @escaping ((Result<MovieDetails, NetworkError>) -> Void)) {
        Networker.getMovieDetails(input: input, completion: completion)
    }
    
    func fetchSimilarMovies(input: Input.SimilarMovies, completion: @escaping ((Result<MoviesList, NetworkError>) -> Void)) {
        Networker.getSimilarMovies(input: input, completion: completion)
    }
    
    func fetchMovieCredits(input: Input.MovieCredits, completion: @escaping ((Result<MovieCredits, NetworkError>) -> Void)) {
        Networker.getMovieCredits(input: input, completion: completion)
    }
}
