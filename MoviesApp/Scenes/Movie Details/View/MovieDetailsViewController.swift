//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

typealias MovieCastCell = UITableViewCell

class MovieDetailsViewController: UIViewController {
    var presenter: MovieDetailsBusinessLogic!
    private var viewModel: MovieDetailsScene.ViewModel = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        presenter.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            cellType: MovieDetailsCell.self, SimilarMoviesCell.self, MovieCastCell.self
        )
        tableView.register(headerFooterViewType: HeaderView.self)
    }
    
    @objc func handleRightBarButtonAction() {
        presenter.didTapRightItemBarButton()
    }
}

extension MovieDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel[section].numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel[indexPath.section] {
        case .movieDetails(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: MovieDetailsCell.self, for: indexPath)
            cell.configure(with: viewModel)
            return cell
        case .similarMovies(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: SimilarMoviesCell.self, for: indexPath)
            cell.configure(with: viewModel)
            return cell
        case .actors(let viewModel), .directors(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: MovieCastCell.self, for: indexPath)
            cell.textLabel?.text = viewModel[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withType: HeaderView.self)
        header.configure(with: viewModel[section].headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel[section].headerHeight
    }
}

extension MovieDetailsViewController: MovieDetailsDisplayLogic {
    func displayMovieDetails(_ viewModel: MovieDetailsScene.Section) {
        appendAndReloadSection(viewModel)
    }
    
    func displaySimilarMovies(_ viewModel: MovieDetailsScene.Section) {
        appendAndReloadSection(viewModel)
    }
    
    func displayMoviesActors(_ viewModel: MovieDetailsScene.Section) {
        appendAndReloadSection(viewModel)
    }
    
    func displayMoviesDirectors(_ viewModel: MovieDetailsScene.Section) {
        appendAndReloadSection(viewModel)
    }
    
    private func appendAndReloadSection(_ viewModel: MovieDetailsScene.Section) {
        self.viewModel.append(viewModel)
        self.tableView.reloadData()
    }
    
    func displayRightItemButton(with title: String) {
        navigationItem.setRightBarButton(
            .init(
                title: title,
                style: .plain,
                target: self,
                action: #selector(handleRightBarButtonAction)
            ),
            animated: true
        )
    }
}

extension MovieDetailsViewController {
}
