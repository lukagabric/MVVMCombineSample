//
//  WeatherViewModel.swift
//  MVVM+RxSwift
//
//  Created by Luka Gabric on 14/02/2017.
//  Copyright © 2017 lukagabric.com. All rights reserved.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    @Published private(set) var locationName: String? = nil
    @Published private(set) var temperature: String? = nil
    @Published private(set) var realFeel: String? = nil
    @Published private(set) var precipitation: String? = nil
    @Published private(set) var updatedAt: String? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var hasFailed: Bool = false
    
    //MARK: - Vars
    
    
    private let weatherDataService: WeatherDataService
    
    init(weatherDataService: WeatherDataService) {
        self.weatherDataService = weatherDataService
    }
    
    func reloadAction() {
        self.isLoading = true
        weatherDataService.fetchWeatherData { [weak self] weatherData, error in
            guard let self = self else { return }
            
            self.isLoading = false
            self.hasFailed = weatherData == nil
            
            guard let weatherData = weatherData else { return }
            
            self.locationName = weatherData.locationName
            self.temperature = String(format: "%.1f\u{00B0}C", weatherData.temperature)
            self.realFeel = String(format: "%.1f\u{00B0}C", weatherData.realFeel)
            self.precipitation = String(format: "%.0f%%", weatherData.precipitation)

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            self.updatedAt = dateFormatter.string(from: weatherData.updatedAt)
        }
    }
    
    //MARK: -
}
