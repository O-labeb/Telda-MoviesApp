//
//  DataStore.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import Foundation

protocol DataStore {
    static var savedMovies: [Int] { get set }
    static func addToWatchList(movieID: Int?)
    static func removeFromWatchList(movieID: Int?)
    static func isMovieAddedToWatchList(movieID: Int?) -> Bool
}

extension DataStore {
    static func addToWatchList(movieID: Int?) {
        guard let movieID else { return }
        let newList = savedMovies + [movieID]
        savedMovies = newList
    }
    
    static func removeFromWatchList(movieID: Int?) {
        guard let movieID else { return }
        let newList = savedMovies.filter({ $0 != movieID })
        savedMovies = newList
    }
    
    static func isMovieAddedToWatchList(movieID: Int?) -> Bool {
        guard let movieID else { return false }
        
        return savedMovies.contains(movieID)
    }
}
