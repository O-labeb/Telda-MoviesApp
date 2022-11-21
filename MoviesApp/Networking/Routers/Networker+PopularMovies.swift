//
//  Networker+PopularMovies.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension Input {
    struct PopularMovies: Encodable {
        let apiKey: String = NetworkingConstants.apiKey
        let page: Int
    }
}

extension Networker {
    static func getPopularMovies(input: Input.PopularMovies, completion: @escaping (Result<MoviesList, NetworkError>) -> Void) {
        let url = URLBuilder.buildUrl(with: ["movie", "popular"])
        fetchData(at: url, with: input, completion: completion)
    }
}
