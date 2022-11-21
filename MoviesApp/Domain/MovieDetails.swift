//
//  MovieDetails.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import Foundation

struct MovieDetails: Decodable {
    let id: Int?
    let title: String?
    let overview: String?
    let releaseDate: Date?
    let posterPath: String?
    let revenue: Int?
    let tagline: String?
    let status: Status?
    
    enum Status: String, Decodable {
        case rumored = "Rumored"
        case inProduction = "In Production"
        case postProduction = "Post Production"
        case planned = "Planned"
        case released = "Released"
        case canceled = "Canceled"
    }
}
