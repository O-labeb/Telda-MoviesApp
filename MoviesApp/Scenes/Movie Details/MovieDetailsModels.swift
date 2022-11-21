//
//  MoviesListModels.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import Foundation

enum MovieDetailsScene {}

extension MovieDetailsScene {
    typealias ViewModel = [Section]
    
    enum Section {
        case movieDetails(viewModel: MovieDetailsCell.ViewModel)
        case similarMovies(viewModel: SimilarMoviesCell.ViewModel)
        case actors(viewModel: [String])
        case directors(viewModel: [String])
        
        var numberOfCells: Int {
            switch self {
            case .movieDetails, .similarMovies:
                return 1
            case .actors(let viewModel):
                return viewModel.count
            case .directors(let viewModel):
                return viewModel.count
            }
        }
        
        var headerViewModel: HeaderView.ViewModel {
            .init(title: headerTitle)
        }
        
        private var headerTitle: String {
            switch self {
            case .movieDetails:
                return "Movie Details"
            case .similarMovies:
                return "Similar Movies"
            case .actors:
                return "Actors"
            case .directors:
                return "Directors"
            }
        }
        
        var headerHeight: CGFloat {
            50
        }
    }
}
