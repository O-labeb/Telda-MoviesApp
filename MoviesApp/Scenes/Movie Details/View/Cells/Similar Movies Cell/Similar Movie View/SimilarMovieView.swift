//
//  SimilarMovieView.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit

class SimilarMovieView: UIView {
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 4
        return view
    }()
    
    let posterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.clipsToBounds = true
        return view
    }()
    
    let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with viewModel: ViewModel) {
        self.init()
        
        label.text = viewModel.title
        posterImageView.loadRemoteImage(at: viewModel.imageURL)
    }
    
    private func setup() {
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(label)
    }
}

extension SimilarMovieView {
    struct ViewModel {
        let title: String?
        let imageURL: String?
    }
}
