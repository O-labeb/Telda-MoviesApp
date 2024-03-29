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
    let dataStore: DataStore.Type
    var groupedMovies: [MoviesListScene.GroupedMovies] = []
    var moviesSource: MoviesListScene.MoviesSource!
    var isPaginating = false
    
    init(
        view: MoviesListDisplayLogic?,
        worker: MoviesListWorkerType,
        dataStore: DataStore.Type
    ) {
        self.view = view
        self.worker = worker
        self.dataStore = dataStore
        
        self.registerWatchListNotificationObserver()
    }
    
    private func registerWatchListNotificationObserver() {
        NotificationCentreManager.observeForNotification(host: self, #selector(updateMovieViaNotificationCentre))
    }
    
    @objc func updateMovieViaNotificationCentre(_ notification: NSNotification) {
        guard let movieID = notification.userInfo?[NotificationCentreManager.Keys.movieID] as? Int else { return }
        
        var movieRowIndex: Int?
        guard
            let movieSectionIndex = groupedMovies.firstIndex(where: { group in
                for i in 0..<group.movies.count {
                    if group.movies[i].id == movieID {
                        movieRowIndex = i
                        return true
                    }
                }
                return false
            }), let movieRowIndex
        else { return }
        
        let indexPath = IndexPath(row: movieRowIndex, section: movieSectionIndex)
        let movie = convertMovieToCellViewModel(groupedMovies[movieSectionIndex].movies[movieRowIndex])
        
        view?.swapMovie(movie, at: indexPath)
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
            self.presentErrorState(msg: error.localizedDescription)
        }
    }
    
    func presentMovies(_ moviesList: MoviesList) {
        guard !moviesList.movies.isEmpty else {
            view?.displayNoResults(.noResults)
            return
        }
        
        
        self.groupedMovies = groupMoviesByYear(moviesList)
        let viewModel = groupedMovies.map(convertGroupedMoviesToSection(_:))
        
        view?.displayMoviesList(.loaded(viewModel: viewModel))
    }
    
    func presentErrorState(msg: String) {
        view?.displayError(.failed(msg))
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
        self.groupedMovies.append(contentsOf: recentlyGroupedMovies)
        
        let viewModel = groupedMovies.map(convertGroupedMoviesToSection(_:))
        
        view?.appendToMoviesList(.loaded(viewModel: viewModel))
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
    
    func convertGroupedMoviesToSection(_ group: MoviesListScene.GroupedMovies) -> MoviesListScene.SectionViewModel {
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
            isAddedToWatchList: dataStore.isMovieAddedToWatchList(movieID: movie.id)
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
