//
//  Spell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Spell: Decodable, Codeable, Nameable, Equatable {
    typealias CoderType = GenericCoder<Spell>

    let name: String
    let damage: String
    let effects: String
    let flavor: String
    
    static func decode(json: AnyObject) throws -> Spell {
        return try Spell(name: json => "name",
            damage: json => "damage",
            effects: json => "effects",
            flavor: json => "flavor")
    }
}

func == (lhs: Spell, rhs: Spell) -> Bool {
    return lhs.name == rhs.name
}

extension Spell: Unarchiveable {
    static var JSONName: String {
        return "Spells"
    }
}
