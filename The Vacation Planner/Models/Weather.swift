//
//  Weather.swift
//  The Vacation Planner
//
//  Created by Everton Baima on 31/03/2018.
//  Copyright © 2018 Snowfox. All rights reserved.
//

import Foundation

public class Weather: Decodable {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
