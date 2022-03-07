//
//  Weather.swift
//  Weather
//
//  Created by Никита Троян on 16.01.2022.
//  Copyright © 2022 JonFir. All rights reserved.
//

import Foundation

typealias Celsius = Double
struct Weather {
    let cityName: String
    let date: Date
    let temperature: Celsius
    let pressure: Double
    let humidity: Double
    let weatherName: String
    let weatherIconName: String?
    let windSpeed: Double
    let windDegrees: Double
}
