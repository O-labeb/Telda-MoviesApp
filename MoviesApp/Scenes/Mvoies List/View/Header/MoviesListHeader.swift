//
//  MoviesListHeader.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

class MoviesListHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }
}
extension MoviesListHeader {
    struct ViewModel {
        let title: String
    }
}
