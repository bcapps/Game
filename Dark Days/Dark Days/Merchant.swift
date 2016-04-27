//
//  Merchant.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/26/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Merchant: Decodable, Nameable {
    let name: String
    let explanation: String
    let location: String
    let items: [String]
    
    static func decode(json: AnyObject) throws -> Merchant {
        return try Merchant(name: json => "name",
                            explanation: json => "explanation",
                            location: json => "location",
                            items: json => "items")
    }
}
