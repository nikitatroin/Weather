//
//  WeatherAdapter.swift
//  Weather
//
//  Created by Никита Троян on 16.01.2022.
//  Copyright © 2022 JonFir. All rights reserved.
//

import Foundation
import RealmSwift

final class WeatherAdapter {
    
    private let weatherService = WeatherService()
    
    private var realmNotificationTokens: [String: NotificationToken] = [:]
    
    func getWeathers(inCity city: String, then completion: @escaping ([Weather]) -> Void) {
        guard let realm = try? Realm()
            , let realmCity = realm.object(ofType: RLMCity.self, forPrimaryKey: city)
            else { return }
        
        let token = realmCity.weathers.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmWeathers, _, _, _):
                var weathers: [Weather] = []
                for realmWeather in realmWeathers {
                    weathers.append(self.weather(from: realmWeather))
                }
                completion(weathers)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        self.realmNotificationTokens[city] = token
        
        weatherService.loadWeatherData(city: city)
    }
    
    private func weather(from rlmWeather: RLMWeather) -> Weather {
        return Weather(cityName: rlmWeather.city,
                       date: Date(timeIntervalSince1970: rlmWeather.date),
                       temperature: rlmWeather.temp,
                       pressure: rlmWeather.pressure,
                       humidity: Double(rlmWeather.humidity),
                       weatherName: rlmWeather.weatherName,
                       weatherIconName: rlmWeather.weatherIcon,
                       windSpeed: rlmWeather.windSpeed,
                       windDegrees: rlmWeather.windDegrees)
    }
}
