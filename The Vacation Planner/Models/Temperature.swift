//
//  Temperature.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 31/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import Foundation

public class Temperature: Decodable {
    let max: Int
    let min: Int
    let unit: String
    
    init(max: Int, min: Int, unit: String) {
        self.max = max
        self.min = min
        self.unit = unit
    }
}
