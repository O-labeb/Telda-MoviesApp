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
    private var viewModel: ViewModel = []
    private var searchDebounceTimer: Timer?
    
    @IBOutlet private weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        
        presenter.fetchPopularMovies()
    }
    
    private func setupTableView() {
        tableView.register(cellType: MovieTableViewCell.self)
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
        viewModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel[section].cellsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: MovieTableViewCell.self, for: indexPath)
        cell.configure(with: viewModel[indexPath.section].cellsViewModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Aspects.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withType: HeaderView.self)
        header.configure(with: viewModel[section].headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Aspects.headerHeight
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
        viewModel[indexPath.section].cellsViewModel[indexPath.row] = movie
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func displayMoviesList(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func appendToMoviesList(_ viewModel: ViewModel) {
        self.viewModel.append(contentsOf: viewModel)
        tableView.reloadData()
    }
}

extension MoviesListViewController {
    enum Aspects {
        static let cellHeight: CGFloat = 200
        static let headerHeight: CGFloat = 64
    }
    
    typealias ViewModel = [SectionViewModel]

    struct SectionViewModel {
        let headerViewModel: HeaderView.ViewModel
        var cellsViewModel: [MovieTableViewCell.ViewModel]
    }
}
