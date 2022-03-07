//
//  RLMWeather.swift
//  Weather
//
//  Created by Евгений Елчев on 27.09.2017.
//  Copyright © 2017 JonFir. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class RLMWeather: Object {
    @objc dynamic var city = ""
    @objc dynamic var date = 0.0
    @objc dynamic var temp = 0.0
    @objc dynamic var pressure = 0.0
    @objc dynamic var humidity = 0
    @objc dynamic var weatherName = ""
    @objc dynamic var weatherIcon = ""
    @objc dynamic var windSpeed = 0.0
    @objc dynamic var windDegrees = 0.0
    
    convenience init(json: JSON, city: String) {
        self.init()
        self.date = json["dt"].doubleValue
        self.temp = json["main"]["temp"].doubleValue
        self.pressure = json["main"]["pressure"].doubleValue
        self.humidity = json["main"]["humidity"].intValue
        self.weatherName = json["weather"][0]["main"].stringValue
        self.weatherIcon = json["weather"][0]["icon"].stringValue
        self.windSpeed = json["wind"]["speed"].doubleValue
        self.windDegrees = json["wind"]["deg"].doubleValue
        self.city = city
    }
}
