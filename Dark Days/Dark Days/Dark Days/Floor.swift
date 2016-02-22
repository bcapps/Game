//
//  Floor.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Floor: Decodable, Nameable {
    let name: String
    let background: String
    let towns: [String]
    
    static func decode(json: AnyObject) throws -> Floor {
        return try Floor(name: json => "name",
            background: json => "background",
            towns: json => "towns")
    }
}
