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
    typealias CoderType = SpellCoder

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

final class SpellCoder: NSObject, Coder {
    typealias Codeable = Spell
    
    private enum Keys: String {
        case Name
    }
    
    var value: Spell?
    
    init(value: Spell) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.spellForName(name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}
