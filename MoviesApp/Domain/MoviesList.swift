//
//  Movie.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

struct MoviesList: Decodable {
    let page: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}

extension MoviesList {
    struct Movie: Decodable {
        let id: Int?
        let title: String?
        let overview: String?
        let releaseDate: Date?
        let posterPath: String?
    }
}
