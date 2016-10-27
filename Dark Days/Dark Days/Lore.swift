//
//  Lore.swift
//  Dark Days
//
//  Created by Andrew Harrison on 10/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Lore: Decodable, Nameable {
    let name: String
    let explanation: String
    
    static func decode(_ json: Any) throws -> Lore {
        return try Lore(name: json => "name",
                        explanation: json => "explanation")
    }
}
