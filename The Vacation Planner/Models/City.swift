//
//  City.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 31/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import Foundation

public class City: Decodable {
    let woeid: String
    let district: String
    let province: String
    let state_acronym: String
    let country: String
    
    init(woeid: String, district: String, province: String, state_acronym: String, country: String) {
        self.woeid = woeid
        self.district = district
        self.province = province
        self.state_acronym = state_acronym
        self.country = country
    }
}
