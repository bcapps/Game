//
//  Race.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Race: Decodable {
    let name: String
    let explanation: String
    let benefits: [String]
    
    static func decode(json: AnyObject) throws -> Race {
        return try Race(
            name: json => "name",
            explanation: json => "explanation",
            benefits: json => "benefits")
    }
}