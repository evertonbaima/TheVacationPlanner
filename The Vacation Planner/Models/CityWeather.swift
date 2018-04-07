//
//  CityWeather.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 31/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import Foundation

public class CityWeather: Decodable {
    let date: String
    let temperature: Temperature
    let weather: String
    let woeid: String
    
    init(date: String, temperature: Temperature, weather: String, woeid: String) {
        self.date = date
        self.temperature = temperature
        self.weather = weather
        self.woeid = woeid
    }
}
