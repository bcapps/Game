//
//  Monster.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Monster: Decodable, Nameable {
    let name: String
    let explanation: String
    let health: Int
    let speed: String
    let attacks: [MonsterAttack]
    let traits: [MonsterTrait]
    let damageImmunities: [String]
    let conditionImmunities: [String]
    let languages: [String]
    let stats: [MonsterStat]
    let type: String
    
    static func decode(_ json: Any) throws -> Monster {
        let traits: [String] = try json => "traits"
        let monsterTraits = traits.flatMap { ObjectProvider.monsterTraitForName($0) }
        
        return try Monster(name: json => "name",
            explanation: json => "explanation",
            health: json => "health",
            speed: json => "speed",
            attacks: json => "attacks",
            traits: monsterTraits,
            damageImmunities: json =>? "damageImmunities" ?? [],
            conditionImmunities: json =>? "conditionImmunities" ?? [],
            languages: json =>? "languages" ?? [],
            stats: json => "stats" ?? [],
            type: json => "type")
    }
        
    func attack(forName name: String) -> MonsterAttack? {
        return attacks.filter { $0.name == name }.first
    }
}
