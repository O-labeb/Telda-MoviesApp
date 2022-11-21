//
//  MoviesListModels.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import Foundation

enum MoviesListScene {}

extension MoviesListScene {
    struct GroupedMovies {
        let date: Date
        var movies: [MoviesList.Movie]
    }
    
    enum MoviesSource {
        case popular(page: Int)
        case search(page: Int, query: String)
        
        mutating func incrementPage() {
            switch self {
            case .popular(let page):
                self = .popular(page: page + 1)
            case .search(let page, let query):
                self = .search(page: page + 1, query: query)
            }
        }
    }
}
