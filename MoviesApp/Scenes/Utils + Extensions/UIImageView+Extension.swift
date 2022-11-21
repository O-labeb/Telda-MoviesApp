//
//  UIImageView+Extension.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadRemoteImage(at url: String?) {
        guard
            let urlString = url,
            let url = URL(string: urlString)
        else { return }
        
        kf.setImage(
            with: url
        )
    }
}
