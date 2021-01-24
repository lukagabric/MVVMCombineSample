//
//  WeatherViewController.swift
//  MVVM+RxSwift
//
//  Created by Luka Gabric on 14/02/2017.
//  Copyright © 2017 lukagabric.com. All rights reserved.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    
    //MARK: - Vars
    
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var realFeelLabel: UILabel!
    @IBOutlet private weak var precipitationLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIButton!
    
    private let viewModel: WeatherViewModel
    
    private var cancellables: [AnyCancellable] = []

    //MARK: - Init
    
    init(weatherDataService: WeatherDataService) {
        viewModel = WeatherViewModel(weatherDataService: weatherDataService)
        super.init(nibName: "WeatherViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
    }
    
    //MARK: - Private
        
    private func configureBindings() {
        let input = WeatherViewModel.Input(refreshAction: refreshAction.eraseToAnyPublisher())
        let bindings = viewModel.bind(input: input)
                
        bindings.locationName.assign(to: \.text, on: locationLabel).store(in: &cancellables)
        bindings.temperature.assign(to: \.text, on: temperatureLabel).store(in: &cancellables)
        bindings.realFeel.assign(to: \.text, on: realFeelLabel).store(in: &cancellables)
        bindings.precipitation.assign(to: \.text, on: precipitationLabel).store(in: &cancellables)
        bindings.updatedAt.assign(to: \.text, on: updatedAtLabel).store(in: &cancellables)
        bindings.isLoading.map { !$0 }.assign(to: \.isHidden, on: loadingView).store(in: &cancellables)
        bindings.isLoading.map { !$0 }.assign(to: \.isEnabled, on: refreshButton).store(in: &cancellables)
        bindings.hasFailed.map { !$0 }.assign(to: \.isHidden, on: errorView).store(in: &cancellables)
    }
    
    private let refreshAction = PassthroughSubject<Void, Never>()
    @IBAction private func refreshAction(_ sender: Any) {
        refreshAction.send(())
    }
    
}

