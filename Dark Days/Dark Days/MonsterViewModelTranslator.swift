//
//  MonsterViewModelTranslator.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

class MonsterViewModelTranslator {
    
    static func transform(_ monster: Monster) -> MonsterView.ViewModel {
        let stats = viewModelStats(forMonster: monster)
        let attacks = viewModelAttacks(forMonster: monster)
        let traits = viewModelTraits(forMonster: monster)
        
        return MonsterView.ViewModel(name: monster.name, type: monster.type, health: String(monster.health), speed: monster.speed, damageImmunities: monster.damageImmunities, conditionImmunites: monster.conditionImmunities, languages: monster.languages, stats: stats, attacks: attacks, traits: traits)
    }
    
    fileprivate static func viewModelStats(forMonster monster: Monster) -> [MonsterView.ViewModel.Stat] {
        return monster.stats.flatMap { MonsterView.ViewModel.Stat(name: $0.name, value: String($0.value)) }
    }
    
    fileprivate static func viewModelAttacks(forMonster monster: Monster) -> [MonsterView.ViewModel.Attack] {
        return monster.attacks.flatMap { MonsterView.ViewModel.Attack(name: $0.name, damage: $0.attack.damageText) }
    }
    
    fileprivate static func viewModelTraits(forMonster monster: Monster) -> [MonsterView.ViewModel.Trait] {
        return monster.traits.flatMap {
            let explanation = $0.explanation.replacingOccurrences(of: "[%name%]", with: monster.name)
            return MonsterView.ViewModel.Trait(name: $0.name, description: explanation)
        }
    }
}
