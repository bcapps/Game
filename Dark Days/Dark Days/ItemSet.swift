//
//  ItemSet.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/12/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct ItemSet: Decodable, Nameable {
    
    let name: String
    let itemNamesInSet: [String]
    let heroEffectGroup: HeroEffectGroup
    let spells: [Spell]
    
    static func decode(_ json: Any) throws -> ItemSet {
        let spellStrings: [String]? = try json =>? "spells"
        let spells = spellStrings?.flatMap { ObjectProvider.spellForName($0) }
        
        return try ItemSet(name: json => "name",
                           itemNamesInSet: json => "itemNamesInSet",
                           heroEffectGroup: json => "heroEffectGroup",
                           spells: spells ?? [])
    }
}
