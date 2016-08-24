//
//  MonsterViewModelTranslator.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

class MonsterViewModelTranslator {
    
    static func transform(monster: Monster) -> MonsterView.ViewModel {
        let stats = viewModelStats(forMonster: monster)
        let attacks = viewModelAttacks(forMonster: monster)
        let traits = viewModelTraits(forMonster: monster)
        
        return MonsterView.ViewModel(name: monster.name, type: monster.type, health: String(monster.health), speed: monster.speed, damageImmunities: monster.damageImmunities, conditionImmunites: monster.conditionImmunities, languages: monster.languages, stats: stats, attacks: attacks, traits: traits)
    }
    
    private static func viewModelStats(forMonster monster: Monster) -> [MonsterView.ViewModel.Stat] {
        return monster.stats.flatMap { MonsterView.ViewModel.Stat(name: $0.name, value: String($0.value)) }
    }
    
    private static func viewModelAttacks(forMonster monster: Monster) -> [MonsterView.ViewModel.Attack] {
        return monster.attacks.flatMap { MonsterView.ViewModel.Attack(name: $0.name, description: $0.damage) }
    }
    
    private static func viewModelTraits(forMonster monster: Monster) -> [MonsterView.ViewModel.Trait] {
        return monster.traits.flatMap { MonsterView.ViewModel.Trait(name: $0.name, description: $0.explanation) }
    }
}
