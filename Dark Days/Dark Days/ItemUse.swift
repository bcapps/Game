//
//  ItemUse.swift
//  Dark Days
//
//  Created by Andrew Harrison on 1/4/17.
//  Copyright © 2017 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct ItemUse: Decodable {
    let damageDiceNumber: Int
    let damageDiceValue: Int
    let additionalDamage: Int?
    
    static func decode(_ json: Any) throws -> ItemUse {
        return try ItemUse(damageDiceNumber: json => "damageDiceNumber",
                          damageDiceValue: json => "damageDiceValue",
                          additionalDamage: json =>? "additionalDamage")
    }
}
