//
//  Networker+PopularMovies.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension Input {
    struct MovieDetails: Encodable {
        let apiKey: String = NetworkingConstants.apiKey
        let movieID: Int
    }
}

extension Networker {
    static func getMovieDetails(input: Input.MovieDetails, completion: @escaping (Result<MovieDetails, NetworkError>) -> Void) {
        let url = URLBuilder.buildUrl(with: ["movie", String(input.movieID)])
        fetchData(at: url, with: input, completion: completion)
    }
}
