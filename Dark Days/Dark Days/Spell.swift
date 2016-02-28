//
//  Spell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Spell: Decodable, Codeable, Nameable {
    typealias CoderType = SpellCoder

    let name: String
    let explanation: String
    
    static func decode(json: AnyObject) throws -> Spell {
        return try Spell(name: json => "name",
            explanation: json => "explanation")
    }
}

final class SpellCoder: NSObject, Coder {
    typealias CodeableType = Spell
    
    private enum Keys: String {
        case Name
    }
    
    var value: Spell?
    
    init(value: Spell) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        
        guard let name = rawName else {
            value = nil
            super.init()
            
            return nil
        }
        
        value = ObjectProvider.spellForName(name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}
