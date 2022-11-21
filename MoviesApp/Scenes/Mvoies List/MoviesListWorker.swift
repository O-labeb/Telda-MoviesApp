//
//  MoviesListWorker.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation
import Alamofire

class MoviesListWorker: MoviesListWorkerType {
    func fetchPopularMovies(input: Input.PopularMovies, completion: @escaping ((Result<MoviesList, NetworkError>) -> Void)) {
        Networker.getPopularMovies(input: input, completion: completion)
    }
    
    var searchRequest: Request?
    func searchMoviesList(input: Input.SearchMovies, completion: @escaping ((Result<MoviesList, NetworkError>) -> Void)) {
        searchRequest?.cancel()
        searchRequest = Networker.searchMovies(input: input, completion: completion)
    }
}
