//
//  Stats.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Stat: Decodable {
    let name: String
    let shortName: String
    let explanation: String
    let benefits: [String]
    
    static func decode(json: AnyObject) throws -> Stat {
        return try Stat(
            name: json => "name",
            shortName: json => "shortName",
            explanation: json => "explanation",
            benefits: json => "benefits"
        )
    }
}