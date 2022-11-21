//
//  Networker+PopularMovies.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension Input {
    struct SearchMovies: Encodable {
        let apiKey: String = NetworkingConstants.apiKey
        let query: String
        let page: Int
    }
}

extension Networker {
    static func searchMovies(input: Input.SearchMovies, completion: @escaping (Result<MoviesList, NetworkError>) -> Void) {
        let url = URLBuilder.buildUrl(with: ["search", "movie"])
        fetchData(at: url, with: input, completion: completion)
    }
}
