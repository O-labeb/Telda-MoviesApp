//
//  TableViewCell.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var watchListImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with viewModel: ViewModel) {
        posterImageView.loadRemoteImage(at: viewModel.imageUrl)
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        watchListImageView.alpha = viewModel.isAddedToWatchList ? 1 : 0.4
    }
}

extension MovieTableViewCell {
    struct ViewModel {
        let imageUrl: String?
        let title: String?
        let overview: String?
        let isAddedToWatchList: Bool
    }
}
