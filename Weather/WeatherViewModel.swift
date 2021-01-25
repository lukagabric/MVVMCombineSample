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
    @Published private(set) var upcomingTemperature: String? = nil
    @Published private(set) var updatedAt: String? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var hasFailed: Bool = false
    
    private var cancellables: [AnyCancellable] = []
    
    //MARK: - Vars
    
    
    private let weatherDataService: WeatherDataService
    
    init(weatherDataService: WeatherDataService) {
        self.weatherDataService = weatherDataService
    }
    
    func reloadAction() {
        self.isLoading = true
        let currentData = weatherDataService.fetchCurrentWeatherData()
        let upcomingData = weatherDataService.fetchUpcomingWeatherData()
            
        Publishers.Zip(currentData, upcomingData)
            .sink { result in
            switch result {
            case .finished: self.hasFailed = false
            case .failure(_): self.hasFailed = true
            }

            self.isLoading = false
        } receiveValue: { [weak self] currentData, upcomingData in
            guard let self = self else { return }

            self.locationName = currentData.locationName
            self.temperature = String(format: "%.1f\u{00B0}C", currentData.temperature)
            self.upcomingTemperature = String(format: "%.1f\u{00B0}C", upcomingData.temperature)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            self.updatedAt = dateFormatter.string(from: currentData.updatedAt)

        }.store(in: &cancellables)
    }
    
    //MARK: -
}
