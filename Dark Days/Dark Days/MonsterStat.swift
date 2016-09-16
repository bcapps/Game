//
//  MonsterStat.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct MonsterStat: Decodable, Nameable {
    let name: String
    let value: Int
    
    static func decode(_ json: Any) throws -> MonsterStat {
        return try MonsterStat(name: json => "name",
                               value: json => "value")
    }
}
