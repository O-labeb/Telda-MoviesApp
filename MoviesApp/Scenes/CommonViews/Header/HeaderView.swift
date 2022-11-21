//
//  MoviesListHeader.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }
}
extension HeaderView {
    struct ViewModel {
        let title: String
    }
}
