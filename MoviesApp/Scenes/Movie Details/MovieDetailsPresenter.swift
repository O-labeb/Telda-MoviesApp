//
//  MovieDetailsPresenter.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

class MovieDetailsPresenter {
    weak var view: MovieDetailsDisplayLogic?
    let worker: MovieDetailsWorkerType
    let movieID: Int
    let dataStore: DataStore.Type
    init(
        view: MovieDetailsDisplayLogic?,
        worker: MovieDetailsWorkerType,
        dataStore: DataStore.Type,
        movieID: Int
    ) {
        self.view = view
        self.worker = worker
        self.movieID = movieID
        self.dataStore = dataStore
    }
}

extension MovieDetailsPresenter: MovieDetailsBusinessLogic {
    func viewDidLoad() {
        fetchMovieDetails()
        
        showInitialRightItemBarButton()
    }
    
    private func showInitialRightItemBarButton() {
        let isMovieAddedToWatchList = dataStore.isMovieAddedToWatchList(movieID: movieID)
        let updatedButtonTitle = isMovieAddedToWatchList ? "Added to watchlist" : "Add to watchlist"
        
        view?.displayRightItemButton(with: updatedButtonTitle)
    }
    
    func didTapRightItemBarButton() {
        let isMovieAddedToWatchList = dataStore.isMovieAddedToWatchList(movieID: movieID)
        let updatedButtonTitle: String
        
        if isMovieAddedToWatchList {
            dataStore.removeFromWatchList(movieID: movieID)
            updatedButtonTitle = "Add to watchlist"
        } else {
            dataStore.addToWatchList(movieID: movieID)
            updatedButtonTitle = "Added to watchlist"
        }

        view?.displayRightItemButton(with: updatedButtonTitle)
        
        NotificationCentreManager.triggerMovieWatchlistChange(movieID: self.movieID)
    }
    
}

private extension MovieDetailsPresenter {
    func fetchMovieDetails() {
        worker.fetchMovieDetails(input: .init(movieID: movieID)) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.presentMovieDetails(movieDetails)
                self?.fetchSimilarMovies()
            case .failure(let error):
                break
            }
        }
    }
    
    func presentMovieDetails(_ details: MovieDetails) {
        let releaseDate: String? = {
            guard let date = details.releaseDate else { return nil }
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM"
            return formatter.string(from: date)
        }()
        
        let revenue: String? = {
            guard let revenue = details.revenue else { return nil }
            return String(revenue)
        }()
        
        let cellViewModel = MovieDetailsCell.ViewModel(
            imageURl: buildImageURl(from: details.posterPath),
            title: details.title,
            overview: details.overview,
            tagline: details.tagline,
            revenue: revenue,
            releaseDate: releaseDate,
            status: details.status?.rawValue
        )
        
        let section = MovieDetailsScene.Section.movieDetails(viewModel: cellViewModel)
        
        view?.displayMovieDetails(section)
    }
    
    func buildImageURl(from string: String?) -> String? {
        guard let string else { return nil }
        return NetworkingConstants.imageURLPrefix + string
    }
}

private extension MovieDetailsPresenter {
    func fetchSimilarMovies() {
        worker.fetchSimilarMovies(input: .init(movieID: movieID)) { [weak self] result in
            switch result {
            case .success(let moviesList):
                self?.presentSimilarMovies(moviesList)
                self?.fetchCastOfSimilarMovies(Array(moviesList.movies.prefix(through: 4)))
            case .failure(let error):
                break
            }
        }
    }
    
    func presentSimilarMovies(_ list: MoviesList) {
        let similarMoviesViewModel = list.movies.prefix(through: 4).map { movie in
            SimilarMovieView.ViewModel(title: movie.title, imageURL: buildImageURl(from: movie.posterPath))
        }

        let section = MovieDetailsScene.Section.similarMovies(viewModel: similarMoviesViewModel)
        view?.displaySimilarMovies(section)
    }
}

private extension MovieDetailsPresenter {
    func fetchCastOfSimilarMovies(_ similarMovies: [MoviesList.Movie]) {
        let group = DispatchGroup()
        var moviesCredits: [MovieCredits] = []
        
        for movie in similarMovies {
            guard let movieID = movie.id else { continue }
            
            group.enter()
            
            worker.fetchMovieCredits(input: .init(movieID: movieID)) { result in
                group.leave()
                
                switch result {
                case .success(let credits):
                    moviesCredits.append(credits)
                case .failure(let error):
                    break
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.filterAndSortMoviesActors(cast: moviesCredits.flatMap({ $0.cast }))
            self?.filterAndSortMoviesDirectors(crew: moviesCredits.flatMap({ $0.crew }))
        }
    }
    
    func filterAndSortMoviesActors(cast: [MovieCredits.Individual]) {
        let topFiveActors = filterOnlyFiveUniquePersons(cast, role: .actor)
        
        view?.displayMoviesActors(.actors(viewModel: topFiveActors))
    }
    
    func filterAndSortMoviesDirectors(crew: [MovieCredits.Individual]) {
        let topFiveDirectors = filterOnlyFiveUniquePersons(crew, role: .director)
        
        view?.displayMoviesActors(.directors(viewModel: topFiveDirectors))
    }
    
    func filterOnlyFiveUniquePersons(_ persons: [MovieCredits.Individual], role: MovieCredits.Individual.Role) -> [String] {
        let topFive = Array(Set(persons)).filter({ $0.role == role }).sorted(by: { $0.popularity > $1.popularity }).prefix(upTo: 5)
        return topFive.map({ $0.name })
    }
}
