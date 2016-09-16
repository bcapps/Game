//
//  ItemSet.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/12/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct ItemSet: Decodable {
    
    let name: String
    let itemNamesInSet: [String]
    let statEffects: [StatEffect]
    let damageReductions: [DamageReduction]
    let damageAvoidances: [DamageAvoidance]
    let attackModifiers: [AttackModifier]
    let damageModifiers: [DamageModifier]
    
    static func decode(_ json: Any) throws -> ItemSet {
        return try ItemSet(name: json => "name",
                           itemNamesInSet: json => "itemNamesInSet",
                           statEffects: json =>? "statEffects" ?? [],
                           damageReductions: json =>? "damageReductions" ?? [],
                           damageAvoidances: json =>? "damageAvoidances" ?? [],
                           attackModifiers: json =>? "attackModifiers" ?? [],
                           damageModifiers: json =>? "damageModifiers" ?? [])
    }
}
