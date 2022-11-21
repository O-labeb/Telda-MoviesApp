//
//  Networker+PopularMovies.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension Input {
    struct SimilarMovies: Encodable {
        let apiKey: String = NetworkingConstants.apiKey
        let movieID: Int
    }
}

extension Networker {
    static func getSimilarMovies(input: Input.SimilarMovies, completion: @escaping (Result<MoviesList, NetworkError>) -> Void) {
        let url = URLBuilder.buildUrl(with: ["movie", String(input.movieID), "similar"])
        fetchData(at: url, with: input, completion: completion)
    }
}
