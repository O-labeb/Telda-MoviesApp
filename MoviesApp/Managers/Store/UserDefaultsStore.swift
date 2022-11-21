//
//  UserDefaultsStore.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import Foundation

enum UserDefaultsStorage: DataStore {
    private static let key = "movieIDs"
    
    static var savedMovies: [Int] {
        get {
            UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
