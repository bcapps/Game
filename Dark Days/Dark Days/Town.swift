//
//  Floor.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Town: Decodable, Nameable {
    let name: String
    let background: String
    let merchants: [String]
    
    static func decode(json: AnyObject) throws -> Town {
        return try Town(name: json => "name",
            background: json => "background",
            merchants: json => "merchants")
    }
}
