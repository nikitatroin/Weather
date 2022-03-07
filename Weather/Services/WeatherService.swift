//
//  WeatherService.swift
//  Weather
//
//  Created by Евгений Елчев on 23.09.17.
//  Copyright © 2017 JonFir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

final class WeatherService {
    
    private let baseUrl = "http://api.openweathermap.org"
    private let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    // MARK: - Methods
    
    func loadWeatherData(city: String) {
        //путь для получния погоды за 5 дней
        let path = "/data/2.5/forecast"
        //параметры: город, единицы измерения - градусы, ключ для доступа к сервису
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": apiKey
        ]
        
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let data = response.value else { return }
            let json = JSON(data)
            let weathers = json["list"].compactMap { RLMWeather(json: $0.1, city: city) }
            self?.saveWeatherData(weathers, city: city)
        }
    }
    
    // MARK: - Private
    
    private func saveWeatherData(_ weathers: [RLMWeather], city: String) {
        do {
            let realm = try Realm()
            guard let city = realm.object(ofType: RLMCity.self, forPrimaryKey: city) else { return }
            
            let oldWeathers = city.weathers
            
            realm.beginWrite()
            realm.delete(oldWeathers)
            city.weathers.append(objectsIn: weathers)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
