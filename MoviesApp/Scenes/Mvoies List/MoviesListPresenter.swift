//
//  MoviesListPresenter.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

class MoviesListPresenter: MoviesListDataStore {
    weak var view: MoviesListDisplayLogic?
    let worker: MoviesListWorkerType
    var groupedMovies: [MoviesListScene.GroupedMovies] = []
    var moviesSource: MoviesListScene.MoviesSource!
    var isPaginating = false
    
    init(
        view: MoviesListDisplayLogic?,
        worker: MoviesListWorkerType
    ) {
        self.view = view
        self.worker = worker
    }
}

extension MoviesListPresenter: MoviesListBusinessLogic {
    func fetchPopularMovies() {
        moviesSource = .popular(page: 1)
        
        worker.fetchPopularMovies(input: .init(page: 1), completion: handleFirstPageMoviesResults(result:))
    }
    
    func searchMoviesFor(query: String) {
        guard !query.isEmpty else {
            return fetchPopularMovies()
        }
        
        moviesSource = .search(page: 1, query: query)
        worker.searchMoviesList(input: .init(query: query, page: 1), completion: handleFirstPageMoviesResults(result:))
    }
    
    func fetchMoreMovies() {
        guard !isPaginating else { return }
        
        isPaginating = true
        
        switch moviesSource! {
        case .search(let page, let query):
            worker.searchMoviesList(
                input: .init(query: query, page: page + 1),
                completion: handlePaginatedMoviesResults(result:)
            )
        case .popular(let page):
            worker.fetchPopularMovies(
                input: .init(page: page + 1),
                completion: handlePaginatedMoviesResults(result:)
            )
        }
        moviesSource.incrementPage()
    }
}

private extension MoviesListPresenter {
    func handleFirstPageMoviesResults(result: Result<MoviesList, NetworkError>) {
        switch result {
        case .success(let moviesList):
            self.presentMovies(moviesList)
        case .failure(let error):
            print(error)
            break
        }
    }
    
    func presentMovies(_ moviesList: MoviesList) {
        self.groupedMovies = groupMoviesByYear(moviesList)
        
        let viewModel = groupedMovies.map(convertGroupedMoviesToSection(_:))
        
        view?.displayMoviesList(viewModel)
    }
    
    func handlePaginatedMoviesResults(result: Result<MoviesList, NetworkError>) {
        isPaginating = false
        
        switch result {
        case .success(let moviesList):
            self.appendAndPresentMovies(moviesList)
        case .failure(let error):
            print(error)
            break
        }
    }
    
    func appendAndPresentMovies(_ moviesList: MoviesList) {
        let recentlyGroupedMovies = groupMoviesByYear(moviesList)
        let viewModel = recentlyGroupedMovies.map(convertGroupedMoviesToSection(_:))

        self.groupedMovies.append(contentsOf: recentlyGroupedMovies)
        
        view?.appendToMoviesList(viewModel)
    }
    
    func groupMoviesByYear(_ moviesList: MoviesList) -> [MoviesListScene.GroupedMovies] {
        var groupedMovies: [MoviesListScene.GroupedMovies] = []
        for movie in moviesList.movies {
            guard
                let movieDate = movie.releaseDate
            else {
                continue
            }
            
            if let indexOfMovieYear = groupedMovies.firstIndex(where: { groupedMovie in
                groupedMovie.date.isInSameYear(with: movieDate)
            }) {
                groupedMovies[indexOfMovieYear].movies.append(movie)
            } else {
                groupedMovies.append(.init(date: movieDate.firstDayInSameYear, movies: [movie]))
            }
            
        }
        return groupedMovies
    }
    
    func convertGroupedMoviesToSection(_ group: MoviesListScene.GroupedMovies) -> MoviesListViewController.SectionViewModel {
        .init(
            headerViewModel: .init(
                title: {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "YYYY"
                    return formatter.string(from: group.date)
                }()
            ),
            cellsViewModel: group.movies.map(convertMovieToCellViewModel(_:))
        )
    }
    
    func convertMovieToCellViewModel(_ movie: MoviesList.Movie) -> MovieTableViewCell.ViewModel {
        .init(
            imageUrl: buildPosterURL(movie.posterPath),
            title: movie.title,
            overview: movie.overview,
            isAddedToWatchList: false
        )
    }
    
    func buildPosterURL(_ posterPath: String?) -> String? {
        guard let posterPath else { return nil }
        return NetworkingConstants.imageURLPrefix + posterPath
    }
}

private extension Date {
    func isInSameYear(with otherDate: Date) -> Bool {
        Calendar.current.dateComponents([.year], from: otherDate, to: self).year == 0
    }
    
    var firstDayInSameYear: Date {
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: self)
        
        return Calendar.current.date(from: components) ?? self
    }
}
