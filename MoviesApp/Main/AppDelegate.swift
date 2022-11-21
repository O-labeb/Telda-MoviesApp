//
//  AppDelegate.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppWindowManager.setupWindow()
        return true
    }
}

