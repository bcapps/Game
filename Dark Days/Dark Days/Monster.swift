//
//  Monster.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Monster: Decodable, Nameable {
    let name: String
    let explanation: String
    let health: Int
    
    static func decode(json: AnyObject) throws -> Monster {
        return try Monster(name: json => "name",
            explanation: json => "explanation",
            health: json => "health")
    }
}