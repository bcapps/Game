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

final class Hero: Codeable {
    typealias CoderType = HeroCoder
    
    let name: String
    let gender: Gender
    let inventory: Inventory
    let stats: [Stat]
    let race: Race
    let skills: [Skill]
    let spells: [Spell]
    let magicType: MagicType
    let god: God?
    let uniqueID: String
    
    var currentHealth: Int = 0
    var maximumHealth: Int {
        get {
            if let constitution = stats.filter({$0.statType == .Constitution}).first {
                return 10 + (constitution.currentValue * 3)
            }
            
            return 10
        }
    }
    
    func increaseStatBy(statType: StatType, value: Int) {
        let statToIncrease = stats.filter { $0.statType == statType }.first
        
        statToIncrease?.currentValue += value
    }
    
    func statValueForType(statType: StatType) -> Int {
        let stat = stats.filter { $0.statType == statType }.first
        
        return stat?.currentValue ?? 0
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
    
    private enum Keys: String {
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
    }
    
    var value: Hero?
    
    init(value: Hero) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        let rawGender = aDecoder.decodeObjectForKey(Keys.Gender.rawValue) as? String
        let rawStats = aDecoder.decodeObjectForKey(Keys.Stats.rawValue) as? [StatCoder]
        let rawRace = aDecoder.decodeObjectForKey(Keys.Race.rawValue) as? RaceCoder
        let rawSkills = aDecoder.decodeObjectForKey(Keys.Skills.rawValue) as? [SkillCoder]
        let rawSpells = aDecoder.decodeObjectForKey(Keys.Spells.rawValue) as? [SpellCoder]
        let rawInventory = aDecoder.decodeObjectForKey(Keys.Inventory.rawValue) as? InventoryCoder
        let rawUniqueID = aDecoder.decodeObjectForKey(Keys.UniqueID.rawValue) as? String
        let rawMagicType = aDecoder.decodeObjectForKey(Keys.MagicType.rawValue) as? MagicTypeCoder
        let rawGod = aDecoder.decodeObjectForKey(Keys.God.rawValue) as? GodCoder
        
        guard let name = rawName, gender = Gender(rawValue: rawGender ?? ""), stats = rawStats?.objects, race = rawRace?.value, skills = rawSkills?.objects, spells = rawSpells?.objects, inventory = rawInventory?.value, magicType = rawMagicType?.value, uniqueID = rawUniqueID else {
            value = nil
            super.init()
            
            return nil
        }
        
        value = Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, spells: spells, magicType: magicType, god: rawGod?.value, uniqueID: uniqueID)
        value?.currentHealth = aDecoder.decodeIntegerForKey(Keys.CurrentHealth.rawValue) ?? 0
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        guard let value = value else {
            return
        }
        
        aCoder.encodeObject(value.name, forKey: Keys.Name.rawValue)
        aCoder.encodeObject(value.gender.rawValue, forKey: Keys.Gender.rawValue)
        aCoder.encodeObject(value.stats.coders, forKey: Keys.Stats.rawValue)
        aCoder.encodeObject(RaceCoder(value: value.race), forKey: Keys.Race.rawValue)
        aCoder.encodeObject(value.skills.coders, forKey: Keys.Skills.rawValue)
        aCoder.encodeObject(value.spells.coders, forKey: Keys.Spells.rawValue)
        aCoder.encodeObject(InventoryCoder(value: value.inventory), forKey: Keys.Inventory.rawValue)
        aCoder.encodeObject(value.uniqueID, forKey: Keys.UniqueID.rawValue)
        aCoder.encodeInteger(value.currentHealth, forKey: Keys.CurrentHealth.rawValue)
        
        if let god = value.god {
            aCoder.encodeObject(GodCoder(value: god), forKey: Keys.God.rawValue)
        }
        
        aCoder.encodeObject(MagicTypeCoder(value: value.magicType), forKey: Keys.MagicType.rawValue)
    }
}
