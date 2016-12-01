//
//  MonsterAttack.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/31/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct MonsterAttack: Decodable, Nameable {
    let name: String
    let attack: Attack
    
    static func decode(_ json: Any) throws -> MonsterAttack {
        return try MonsterAttack(name: json => "name",
                               attack: json => "attack")
    }
}
