//
//  JsonDecoder.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

extension JSONDecoder {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
        )
        return decoder
    }
}
