//
//  StatusEffect.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/4/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct StatusEffect: Decodable, Codeable, Nameable, Equatable {
    typealias CoderType = StatusEffectCoder
    
    let name: String
    let statModifiers: [StatModifier]
    let damageReductions: [DamageReduction]
    let damageAvoidances: [DamageAvoidance]
    let attackModifiers: [AttackModifier]
    let damageModifiers: [DamageModifier]
    
    static func decode(_ json: Any) throws -> StatusEffect {
        return try StatusEffect(name: json => "name",
                                statModifiers: json =>? "statModifiers" ?? [],
                                damageReductions: json =>? "damageReductions" ?? [],
                                damageAvoidances: json =>? "damageAvoidances" ?? [],
                                attackModifiers: json =>? "attackModifiers" ?? [],
                                damageModifiers: json =>? "damageModifiers" ?? [])
    }
}

func == (lhs: StatusEffect, rhs: StatusEffect) -> Bool {
    return lhs.name == rhs.name
}

final class StatusEffectCoder: NSObject, Coder {
    typealias Codeable = StatusEffect
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: StatusEffect?
    
    init(value: StatusEffect) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String else { return nil }
        
        value = ObjectProvider.statusEffectForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
