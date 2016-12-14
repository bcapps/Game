//
//  HeroEffect.swift
//  Dark Days
//
//  Created by Andrew Harrison on 12/14/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct HeroEffectGroup: Decodable {
    
    let statModifiers: [StatModifier]
    let damageReductions: [DamageReduction]
    let damageAvoidances: [DamageAvoidance]
    let attackModifiers: [AttackModifier]
    let damageModifiers: [DamageModifier]
    
    init(statModifiers: [StatModifier] = [], damageReductions: [DamageReduction] = [], damageAvoidances: [DamageAvoidance] = [], attackModifiers: [AttackModifier] = [], damageModifiers: [DamageModifier] = []) {
        self.statModifiers = statModifiers
        self.damageReductions = damageReductions
        self.damageAvoidances = damageAvoidances
        self.attackModifiers = attackModifiers
        self.damageModifiers = damageModifiers
    }
    
    static func decode(_ json: Any) throws -> HeroEffectGroup {
        return try HeroEffectGroup(statModifiers: json =>? "statModifiers" ?? [],
                                   damageReductions: json =>? "damageReductions" ?? [],
                                   damageAvoidances: json =>? "damageAvoidances" ?? [],
                                   attackModifiers: json =>? "attackModifiers" ?? [],
                                   damageModifiers: json =>? "damageModifiers" ?? [])
    }
}
