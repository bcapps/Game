//
//  Attack.swift
//  Dark Days
//
//  Created by Andrew Harrison on 12/1/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Attack: Decodable {
    let damageDiceNumber: Int
    let damageDiceValue: Int
    let additionalDamage: Int?
    let damageText: String
    let damageStat: StatType
    let attackType: AttackModifierType
    
    static func decode(_ json: Any) throws -> Attack {
        let statType = StatType.statTypeForShortName(string: try json => "damageStat")
        let attackModifierType = AttackModifierType.attackModifierTypeForName(name: try json => "attackType")
        
        return try Attack(damageDiceNumber: json => "damageDiceNumber",
                          damageDiceValue: json => "damageDiceValue",
                          additionalDamage: json =>? "additionalDamage",
                          damageText: json => "damageText",
                          damageStat: statType,
                          attackType: attackModifierType)
    }
}
