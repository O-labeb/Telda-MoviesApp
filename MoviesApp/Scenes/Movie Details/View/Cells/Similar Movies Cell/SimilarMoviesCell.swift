//
//  SimilarMoviesCell.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

class SimilarMoviesCell: UITableViewCell {
    @IBOutlet weak var scrollableStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(with viewModel: ViewModel) {
        scrollableStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        viewModel.forEach { viewModel in
            let view = SimilarMovieView(with: viewModel)
            scrollableStackView.addArrangedSubview(view)
        }
    }
}

extension SimilarMoviesCell {
    typealias ViewModel = [SimilarMovieView.ViewModel]
}
