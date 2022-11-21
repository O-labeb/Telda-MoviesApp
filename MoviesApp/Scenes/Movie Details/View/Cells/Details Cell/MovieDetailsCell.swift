//
//  MovieDetailsCell.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

class MovieDetailsCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(with viewModel: ViewModel) {
        posterImageView.loadRemoteImage(at: viewModel.imageURl)
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        taglineLabel.text = viewModel.tagline
        revenueLabel.text = viewModel.revenue
        releaseDateLabel.text = viewModel.releaseDate
        statusLabel.text = viewModel.status
    }
}

extension MovieDetailsCell {
    struct ViewModel {
        let imageURl: String?
        let title: String?
        let overview: String?
        let tagline: String?
        let revenue: String?
        let releaseDate: String?
        let status: String?
    }
}
