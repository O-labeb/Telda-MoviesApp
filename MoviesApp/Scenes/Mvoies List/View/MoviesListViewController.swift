//
//  MoviesListViewController.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import UIKit

class MoviesListViewController: UIViewController {
    var presenter: MoviesListBusinessLogic!
    var router: MoviesListRoutingLogic!
    private var sceneState = MoviesListScene.SceneState.idle
    private var searchDebounceTimer: Timer?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        
        activityIndicator.startAnimating()
        presenter.fetchPopularMovies()
    }
    
    private func setupTableView() {
        tableView.register(
            cellType: MovieTableViewCell.self, UITableViewCell.self
        )
        tableView.register(headerFooterViewType: HeaderView.self)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Start typing ..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard case .loaded(let viewModel) = sceneState else { return 1 }
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sceneState {
        case .loaded(let viewModel):
            return viewModel[section].cellsViewModel.count
        case .idle:
            return 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sceneState {
        case .loaded(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: MovieTableViewCell.self, for: indexPath)
            cell.configure(with: viewModel[indexPath.section].cellsViewModel[indexPath.row])
            return cell
        case .failed(let errorMsg):
            let cell = tableView.dequeueReusableCell(withType: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = errorMsg
            return cell
        case .noResults, .idle:
            let cell = tableView.dequeueReusableCell(withType: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = "No Result Found"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Aspects.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard case .loaded(let viewModel) = sceneState else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withType: HeaderView.self)
        header.configure(with: viewModel[section].headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard case .loaded = sceneState else { return 0 }
        return Aspects.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToMovieDetails(at: indexPath)
    }
}

extension MoviesListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let isLastRowInLastSection: Bool = {
                let lastSectionIndex = tableView.numberOfSections - 1
                return indexPath.section == lastSectionIndex && indexPath.row == tableView.numberOfRows(inSection: lastSectionIndex) - 1
            }()
            
            if isLastRowInLastSection {
                presenter.fetchMoreMovies()
            }
        }
    }
}

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let searchQuery = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(
            withTimeInterval: 0.3,
            repeats: false
        ) { [weak self] _ in
            self?.presenter.searchMoviesFor(query: searchQuery)
        }
    }
}

extension MoviesListViewController: MoviesListDisplayLogic {
    func swapMovie(_ movie: MovieTableViewCell.ViewModel, at indexPath: IndexPath) {
        guard case .loaded(let viewModel) = sceneState else { return }
        
        var tempViewModel = viewModel
        tempViewModel[indexPath.section].cellsViewModel[indexPath.row] = movie
        self.sceneState = .loaded(viewModel: tempViewModel)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func displayMoviesList(_ viewState: MoviesListScene.SceneState) {
        activityIndicator.stopAnimating()
        
        self.sceneState = viewState
        tableView.reloadData()
    }
    
    func appendToMoviesList(_ viewState: MoviesListScene.SceneState) {
        self.sceneState = viewState
        tableView.reloadData()
    }
    
    func displayError(_ viewState: MoviesListScene.SceneState) {
        activityIndicator.stopAnimating()
        
        self.sceneState = viewState
        tableView.reloadData()
    }
    
    func displayNoResults(_ viewState: MoviesListScene.SceneState) {
        activityIndicator.stopAnimating()
        
        self.sceneState = viewState
        tableView.reloadData()
    }
}

extension MoviesListViewController {
    enum Aspects {
        static let cellHeight: CGFloat = 200
        static let headerHeight: CGFloat = 64
    }
}
