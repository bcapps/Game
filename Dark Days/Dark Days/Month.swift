//
//  Month.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/16/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Month: Decodable, Nameable {
    let name: String
    let days: Int
    
    static func decode(_ json: Any) throws -> Month {
        return try Month(name: json => "name",
                         days: json => "days")
    }
}
