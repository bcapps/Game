//
//  ItemEffect.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct StatEffect: Decodable {
    let stat: String
    let value: Int
    
    static func decode(_ json: Any) throws -> StatEffect {
        return try StatEffect(stat: json => "stat",
                              value: json => "value")
    }
}
