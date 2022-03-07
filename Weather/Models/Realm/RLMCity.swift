//
//  RLMCity.swift
//  Weather
//
//  Created by Евгений Елчев on 07.10.2017.
//  Copyright © 2017 JonFir. All rights reserved.
//

import Foundation
import RealmSwift

class RLMCity: Object {
    @objc dynamic var name = ""
    let weathers = List<RLMWeather>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
