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
    @IBOutlet private weak var upcomingTemperatureLabel: UILabel!
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
        
        viewModel.reloadAction()
    }
    
    //MARK: - Private
        
    private func configureBindings() {
        viewModel.$locationName.assign(to: \.text, on: locationLabel).store(in: &cancellables)
        viewModel.$temperature.assign(to: \.text, on: temperatureLabel).store(in: &cancellables)
        viewModel.$upcomingTemperature.assign(to: \.text, on: upcomingTemperatureLabel).store(in: &cancellables)
        viewModel.$updatedAt.assign(to: \.text, on: updatedAtLabel).store(in: &cancellables)
        viewModel.$isLoading.map { !$0 }.assign(to: \.isHidden, on: loadingView).store(in: &cancellables)
        viewModel.$isLoading.map { !$0 }.assign(to: \.isEnabled, on: refreshButton).store(in: &cancellables)
        viewModel.$hasFailed.map { !$0 }.assign(to: \.isHidden, on: errorView).store(in: &cancellables)
    }
    
    @IBAction private func refreshAction(_ sender: Any) {
        viewModel.reloadAction()
    }
    
}

