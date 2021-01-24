//
//  AppDelegate.swift
//  Weather
//
//  Created by Luka Gabrić on 23/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WeatherViewController(weatherDataService: WeatherDataService())
        window?.makeKeyAndVisible()
        return true
    }
    
}

