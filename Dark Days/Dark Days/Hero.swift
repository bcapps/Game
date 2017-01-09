//
//  Hero.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

enum Gender: String {
    case Female
    case Male
}

final class Hero: Codeable, Nameable {
    typealias CoderType = HeroCoder
    
    let name: String
    let gender: Gender
    let inventory: Inventory
    let stats: [Stat]
    let race: Race
    var skills: [Skill]
    var spells: [Spell]
    let magicType: MagicType
    let god: God?
    let uniqueID: String
    
    var currentStatusEffects: [StatusEffect] = []
    var currentHealth: Int = 0
    var maximumHealth: Int {
        get {
            if let constitution = stats.filter({$0.statType == .Constitution}).first {
                return 10 + (constitution.currentValue * 4)
            }
            
            return 10
        }
    }
    
    func increaseStatBy(_ statType: StatType, value: Int) {
        let statToIncrease = stats.filter { $0.statType == statType }.first
        
        statToIncrease?.currentValue += value
    }
    
    func statValueForType(_ statType: StatType) -> Int {
        let optionalStat = stats.filter { $0.statType == statType }.first
        
        guard let stat = optionalStat else { return 0 }
        
        return stat.currentValue + statModifierForEquippedItemsForStat(stat) + statModifierForCurrentStatuses(forStat: stat) + statModifierForSkills(forStat: stat)
    }
    
    func damageReductionForReductionType(_ type: DamageReduction.ReductionType) -> Int {
        var reductionCounter = 0
        
        switch type {
        case .Poison:
            reductionCounter += Int(ceil(Double(statValueForType(.Constitution)) / 2))
        default:
            reductionCounter += 0
        }
        
        let itemModifiers = inventory.equippedItems.map { $0.heroEffectGroup.damageReductions }.flatMap { $0 }
        let itemSetModifiers = inventory.equippedItemSets.map { $0.heroEffectGroup.damageReductions }.flatMap { $0 }
        let statusEffectModifiers = currentStatusEffects.map { $0.heroEffectGroup.damageReductions }.flatMap { $0 }
        let skillModifiers = skills.flatMap { $0.heroEffectGroup?.damageReductions }.flatMap { $0 }
        
        let reductionModifiers = itemModifiers + itemSetModifiers + statusEffectModifiers + skillModifiers

        reductionCounter += reductionModifiers.filter { $0.reductionType == type }.map { $0.value }.reduce(0, +)
        
        return reductionCounter
    }
    
    func damageAvoidanceForAvoidanceType(_ type: DamageAvoidance.AvoidanceType) -> Int {
        var avoidanceCounter = 0
        
        switch type {
        case .Physical:
            avoidanceCounter += statValueForType(.Dexterity)
        case .Magical:
            avoidanceCounter += statValueForType(.Intelligence)
        case .Mental:
            avoidanceCounter += statValueForType(.Faith)
        }
        
        let itemModifiers = inventory.equippedItems.map { $0.heroEffectGroup.damageAvoidances }.flatMap { $0 }
        let itemSetModifiers = inventory.equippedItemSets.map { $0.heroEffectGroup.damageAvoidances }.flatMap { $0 }
        let statusEffectModifiers = currentStatusEffects.map { $0.heroEffectGroup.damageAvoidances }.flatMap { $0 }
        let skillModifiers = skills.flatMap { $0.heroEffectGroup?.damageAvoidances }.flatMap { $0 }
        
        let avoidanceModifiers = itemModifiers + itemSetModifiers + statusEffectModifiers + skillModifiers
        
        avoidanceCounter += avoidanceModifiers.filter { $0.avoidanceType == type }.map { $0.value }.reduce(0, +)
        
        return avoidanceCounter
    }
        
    func damageModifier(forAttack attack: Attack, modifierType type: DamageModifier.DamageModifierType) -> Int {
        return damageModifierForStatType(statType: attack.damageStat, type: type)
    }
    
    func damageModifierForModifierType(_ type: DamageModifier.DamageModifierType) -> Int {
        let statType: StatType
        
        switch type {
        case .Physical:
            statType = .Strength
        case .Magical:
            statType = .Faith
        }
        
        return damageModifierForStatType(statType: statType, type: type)
    }
    
    private func damageModifierForStatType(statType: StatType, type: DamageModifier.DamageModifierType) -> Int {
        let itemModifiers = inventory.equippedItems.map { $0.heroEffectGroup.damageModifiers }.flatMap { $0 }
        let itemSetModifiers = inventory.equippedItemSets.map { $0.heroEffectGroup.damageModifiers }.flatMap { $0 }
        let statusEffectModifiers = currentStatusEffects.map { $0.heroEffectGroup.damageModifiers }.flatMap { $0 }
        let skillModifiers = skills.flatMap { $0.heroEffectGroup?.damageModifiers }.flatMap { $0 }
        
        let damageModifiers = itemModifiers + itemSetModifiers + statusEffectModifiers + skillModifiers
        
        let damageModifier = damageModifiers.filter { $0.attackModifierType == type }.map { $0.value }.reduce(0, +)
        
        return damageModifier + statValueForType(statType)
    }
    
    func attackModifier(forAttackType type: AttackModifierType) -> Int {
        var attackModifier = 0
        
        switch type {
        case .Melee:
            attackModifier += statValueForType(.Strength)
        case .Ranged:
            attackModifier += statValueForType(.Dexterity)
        case .Magical:
            attackModifier += statValueForType(.Intelligence)
        }
        
        let itemModifiers = inventory.equippedItems.map { $0.heroEffectGroup.attackModifiers }.flatMap { $0 }
        let itemSetModifiers = inventory.equippedItemSets.map { $0.heroEffectGroup.attackModifiers }.flatMap { $0 }
        let statusEffectModifiers = currentStatusEffects.map { $0.heroEffectGroup.attackModifiers }.flatMap { $0 }
        let skillModifiers = skills.flatMap { $0.heroEffectGroup?.attackModifiers }.flatMap { $0 }
        
        let attackModifiers = itemModifiers + itemSetModifiers + statusEffectModifiers + skillModifiers
        
        attackModifier += attackModifiers.filter { $0.attackModifierType == type }.map { $0.value }.reduce(0, +)
        
        return attackModifier
    }
    
    func statModifierForEquippedItemsForStat(_ stat: Stat) -> Int {
        let itemModifiers = inventory.equippedItems.map { $0.heroEffectGroup.statModifiers }.flatMap { $0 }.filter { $0.stat == stat.shortName }.flatMap { $0 }
        let itemSetModifiers = inventory.equippedItemSets.map { $0.heroEffectGroup.statModifiers }.flatMap { $0 }.filter { $0.stat == stat.shortName }.flatMap { $0 }
        
        let statModifiers = itemModifiers + itemSetModifiers
        
        return statModifiers.map { $0.value }.reduce(0, +)
    }
    
    func statModifierForCurrentStatuses(forStat stat: Stat) -> Int {
        return currentStatusEffects.map { $0.heroEffectGroup.statModifiers }.joined().filter { $0.stat == stat.shortName }.map { return $0.value }.reduce(0, {$0 + $1})
    }
    
    func statModifierForSkills(forStat stat: Stat) -> Int {
        return skills.flatMap { $0.heroEffectGroup?.statModifiers }.joined().filter { $0.stat == stat.shortName }.map { $0.value }.reduce(0, +)
    }
    
    init(name: String, gender: Gender, inventory: Inventory, stats: [Stat], race: Race, skills: [Skill], spells: [Spell], magicType: MagicType, god: God?, uniqueID: String) {
        self.name = name
        self.gender = gender
        self.inventory = inventory
        self.stats = stats
        self.race = race
        self.skills = skills
        self.spells = spells
        self.magicType = magicType
        self.god = god
        self.uniqueID = uniqueID
    }
}

final class HeroCoder: NSObject, Coder {
    typealias CodeableType = Hero
    
    fileprivate enum Keys: String {
        case Name
        case Gender
        case Inventory
        case Stats
        case Race
        case Skills
        case Spells
        case MagicType
        case God
        case UniqueID
        case CurrentHealth
        case CurrentStatusEffects
    }
    
    var value: Hero?
    
    init(value: Hero) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        let rawGender = aDecoder.decodeObject(forKey: Keys.Gender.rawValue) as? String
        let rawStats = aDecoder.decodeObject(forKey: Keys.Stats.rawValue) as? [StatCoder]
        let rawRace = aDecoder.decodeObject(forKey: Keys.Race.rawValue) as? RaceCoder
        let rawSkills = aDecoder.decodeObject(forKey: Keys.Skills.rawValue) as? [SkillCoder]
        let rawSpells = aDecoder.decodeObject(forKey: Keys.Spells.rawValue) as? [SpellCoder]
        let rawInventory = aDecoder.decodeObject(forKey: Keys.Inventory.rawValue) as? InventoryCoder
        let rawUniqueID = aDecoder.decodeObject(forKey: Keys.UniqueID.rawValue) as? String
        let rawMagicType = aDecoder.decodeObject(forKey: Keys.MagicType.rawValue) as? MagicTypeCoder
        let rawGod = aDecoder.decodeObject(forKey: Keys.God.rawValue) as? GodCoder
        let rawStatusEffects = aDecoder.decodeObject(forKey: Keys.CurrentStatusEffects.rawValue) as? [StatusEffectCoder]
        
        guard let name = rawName, let gender = Gender(rawValue: rawGender ?? ""), let stats = rawStats?.objects, let race = rawRace?.value, let skills = rawSkills?.objects, let spells = rawSpells?.objects, let inventory = rawInventory?.value, let magicType = rawMagicType?.value, let uniqueID = rawUniqueID else { return nil }
        
        value = Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, spells: spells, magicType: magicType, god: rawGod?.value, uniqueID: uniqueID)
        value?.currentHealth = aDecoder.decodeInteger(forKey: Keys.CurrentHealth.rawValue) 
        value?.currentStatusEffects = rawStatusEffects?.objects ?? []
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        guard let value = value else {
            return
        }
        
        aCoder.encode(value.name, forKey: Keys.Name.rawValue)
        aCoder.encode(value.gender.rawValue, forKey: Keys.Gender.rawValue)
        aCoder.encode(value.stats.coders, forKey: Keys.Stats.rawValue)
        aCoder.encode(RaceCoder(value: value.race), forKey: Keys.Race.rawValue)
        aCoder.encode(value.skills.coders, forKey: Keys.Skills.rawValue)
        aCoder.encode(value.spells.coders, forKey: Keys.Spells.rawValue)
        aCoder.encode(InventoryCoder(value: value.inventory), forKey: Keys.Inventory.rawValue)
        aCoder.encode(value.uniqueID, forKey: Keys.UniqueID.rawValue)
        aCoder.encode(value.currentHealth, forKey: Keys.CurrentHealth.rawValue)
        aCoder.encode(value.currentStatusEffects.coders, forKey: Keys.CurrentStatusEffects.rawValue)
        
        if let god = value.god {
            aCoder.encode(GodCoder(value: god), forKey: Keys.God.rawValue)
        }
        
        aCoder.encode(MagicTypeCoder(value: value.magicType), forKey: Keys.MagicType.rawValue)
    }
}
