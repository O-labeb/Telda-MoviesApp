//
//  AppWindowManager.swift
//  MoviesApp
//
//  Created by Omar Labib on 18/11/2022.
//

import UIKit

enum AppWindowManager {
    static func setupWindow() {
        window = .init(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        window.rootViewController = entryViewController
    }
}

private extension AppWindowManager {
    static var window: UIWindow {
        get {
            (UIApplication.shared.delegate as? AppDelegate)!.window!
        }
        set {
            (UIApplication.shared.delegate as? AppDelegate)?.window = newValue
        }
    }
    
    static var entryViewController: UIViewController {
        UINavigationController(rootViewController: MoviesListConfigurator.configure())
    }
}
