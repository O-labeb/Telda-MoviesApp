//
//  NotificationManager.swift
//  MoviesApp
//
//  Created by Omar Labib on 19/11/2022.
//

import Foundation

enum NotificationCentreManager {
    enum Keys {
        static let movieID = "movieID"
    }
    
    static func triggerMovieWatchlistChange(movieID: Int) {
        NotificationCenter.default.post(name: .watchlist, object: nil, userInfo: [Keys.movieID: movieID])
    }
    
    static func observeForNotification(host: Any, _ observer: Selector) {
        NotificationCenter.default.addObserver(host, selector: observer, name: .watchlist, object: nil)
    }
}

private extension Notification.Name {
    static let watchlist = Notification.Name("watchlist")
}
