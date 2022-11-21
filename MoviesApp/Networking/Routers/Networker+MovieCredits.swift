//
//  Networker+PopularMovies.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension Input {
    struct MovieCredits: Encodable {
        let apiKey: String = NetworkingConstants.apiKey
        let movieID: Int
    }
}

extension Networker {
    static func getMovieCredits(input: Input.MovieCredits, completion: @escaping (Result<MovieCredits, NetworkError>) -> Void) {
        let url = URLBuilder.buildUrl(with: ["movie", String(input.movieID), "credits"])
        fetchData(at: url, with: input, completion: completion)
    }
}
