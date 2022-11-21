//
//  URLBuilder.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

enum URLBuilder {
    static func buildUrl(with components: [String]) -> String {
        NetworkingConstants.baseURL + "/" + components.joined(separator: "/")
    }
}
