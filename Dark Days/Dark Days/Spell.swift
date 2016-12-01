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
    let attack: Attack?
    let effects: String
    let flavor: String
    
    static func decode(_ json: Any) throws -> Spell {
        return try Spell(name: json => "name",
            attack: json =>? "attack",
            effects: json => "effects",
            flavor: json => "flavor")
    }
}

func == (lhs: Spell, rhs: Spell) -> Bool {
    return lhs.name == rhs.name
}

final class SpellCoder: NSObject, Coder {
    typealias Codeable = Spell
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: Spell?
    
    init(value: Spell) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String else { return nil }
        
        value = ObjectProvider.spellForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
