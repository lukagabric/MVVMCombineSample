//
//  WeatherViewModel.swift
//  MVVM+RxSwift
//
//  Created by Luka Gabric on 14/02/2017.
//  Copyright © 2017 lukagabric.com. All rights reserved.
//

import Foundation
import Combine

class WeatherViewModel {
    
    struct Input {
        let refreshAction: AnyPublisher<Void, Never>
    }
    struct Output {
        let locationName: AnyPublisher<String?, Never>
        let temperature: AnyPublisher<String?, Never>
        let realFeel: AnyPublisher<String?, Never>
        let precipitation: AnyPublisher<String?, Never>
        let updatedAt: AnyPublisher<String?, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let hasFailed: AnyPublisher<Bool, Never>
    }
    
    //MARK: - Vars
    
    
    let weatherDataService: WeatherDataService
    
    init(weatherDataService: WeatherDataService) {
        self.weatherDataService = weatherDataService
    }
    
    private enum WeatherDataEvent {
        case loading
        case weatherData(WeatherData)
        case error
    }
    
    func bind(input: Input) -> Output {
        let weatherDataEvent = input.refreshAction
            .prepend(())
            .setFailureType(to: Never.self)
            .map { [weatherDataService] _ -> AnyPublisher<WeatherDataEvent, Never> in
                weatherDataService.fetchWeatherData()
                    .map { .weatherData($0) }
                    .prepend(.loading)
                    .replaceError(with: .error)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()

        let weatherData = weatherDataEvent
            .map { event -> AnyPublisher<WeatherData, Never> in
                switch event {
                case .weatherData(let data):
                    return Just(data)
                        .setFailureType(to: Never.self)
                        .eraseToAnyPublisher()
                default:
                    return Empty(completeImmediately: true, outputType: WeatherData.self, failureType: Never.self)
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
        
        let locationName = weatherData
            .map { $0.locationName }
            .prepend(nil)
            .eraseToAnyPublisher()
        
        let temperature = weatherData
            .map { String(format: "%.1f\u{00B0}C", $0.temperature) }
            .prepend(nil)
            .eraseToAnyPublisher()
        
        let realFeel = weatherData
            .map { String(format: "%.1f\u{00B0}C", $0.realFeel) }
            .prepend(nil)
            .eraseToAnyPublisher()
        
        let precipitation = weatherData
            .map { String(format: "%.0f%%", $0.precipitation) }
            .prepend(nil)
            .eraseToAnyPublisher()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        let updatedAt = weatherData
            .map { dateFormatter.string(from: $0.updatedAt) }
            .prepend(nil)
            .eraseToAnyPublisher()
        
        let isLoading = weatherDataEvent
            .map { event -> Bool in
                switch event {
                case .loading: return true
                default: return false
                }
            }
            .eraseToAnyPublisher()
        
        let hasFailed = weatherDataEvent
            .map { event -> Bool in
                switch event {
                case .error: return true
                default: return false
                }
            }
            .eraseToAnyPublisher()
        
        let output = Output(
            locationName: locationName,
            temperature: temperature,
            realFeel: realFeel,
            precipitation: precipitation,
            updatedAt: updatedAt,
            isLoading: isLoading,
            hasFailed: hasFailed
        )
                
        return output
    }
    
    //MARK: -
}
