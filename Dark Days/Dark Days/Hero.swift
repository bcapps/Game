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

struct Hero: Codeable {
    typealias CoderType = HeroCoder
    
    let name: String
    let gender: Gender
    let inventory: Inventory
    let stats: [Stat]
    let race: Race
    let skills: [Skill]
    let uniqueID: String
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
        case UniqueID
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
        let rawInventory = aDecoder.decodeObjectForKey(Keys.Inventory.rawValue) as? InventoryCoder
        let rawUniqueID = aDecoder.decodeObjectForKey(Keys.UniqueID.rawValue) as? String
        
        guard let name = rawName, gender = Gender(rawValue: rawGender ?? ""), stats = rawStats?.objects, race = rawRace?.value, skills = rawSkills?.objects, inventory = rawInventory?.value, uniqueID = rawUniqueID else {
            value = nil
            super.init()
            
            return nil
        }
        
        value = Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, uniqueID: uniqueID)
        
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
        aCoder.encodeObject(InventoryCoder(value: value.inventory), forKey: Keys.Inventory.rawValue)
        aCoder.encodeObject(value.uniqueID, forKey: Keys.UniqueID.rawValue)
    }
}