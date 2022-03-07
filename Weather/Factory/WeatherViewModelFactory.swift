//
//  WeatherViewModelFactory.swift
//  Weather
//
//  Created by Никита Троян on 16.01.2022.
//  Copyright © 2022 JonFir. All rights reserved.
//

import UIKit

final class WeatherViewModelFactory {
    
    func constructViewModels(from weathers: [Weather]) -> [WeatherViewModel] {
        return weathers.compactMap{self.viewModel(from: $0)}
    }
    
    private func viewModel(from weather: Weather) -> WeatherViewModel {
        let weatherText = String(Int(round(weather.temperature)))
        let dateText = WeatherViewModelFactory.dateFormatter.string(from: weather.date)
        let iconImage = UIImage(named: weather.weatherIconName ?? "")
        let colorTone = min(abs(weather.temperature) * 10, 255.0)
        let shadowColor: UIColor
        if weather.temperature <= 0 {
            shadowColor = UIColor.rgba(0.0, 50.0, b: CGFloat(colorTone), a: 1.0)
        } else {
            shadowColor = UIColor.rgba(CGFloat(colorTone), 0.0, b: 0.0, a: 1.0)
        }
        return WeatherViewModel(weatherText: weatherText, dateText: dateText, iconImage: iconImage, shadowColor: shadowColor)
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
        return dateFormatter
    }()
}
