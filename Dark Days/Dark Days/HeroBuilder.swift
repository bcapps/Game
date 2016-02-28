//
//  HeroBuilder.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class HeroBuilder {
    
    var name: String = ""
    var gender: Gender = .Male
    var skill: Skill?
    var race: Race = Race(name: "", explanation: "", benefits: [])
    var stats: [Stat] = ObjectProvider.objectsForJSON("Stats")
    var magicType: MagicType = MagicType(name: "", explanation:  "", benefits:  [])
    var god: God?
    
    func build() -> Hero? {
        let inventory = Inventory()
        
        var skills = [Skill]()
        if let skill = skill {
            skills.append(skill)
        }
        
        let spells = spellsForGod(god)
                
        return Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, spells: spells, magicType: magicType, god: god, uniqueID: NSUUID().UUIDString)
    }
        
    func increaseStatValue(value: Int, type: StatType) {
        let stat = stats.filter({$0.statType == type}).first
        stat?.currentValue += value
    }
    
    private func spellsForGod(god: God?) -> [Spell] {
        var spells = [Spell]()
        
        if let name = god?.name {
            switch(name) {
            case "Shiro, God of Hope":
                let reflect = ObjectProvider.spellForName("Reflect")
                let ray = ObjectProvider.spellForName("Ray of Light")
                let inspire = ObjectProvider.spellForName("Inspire")

                if let reflect = reflect, ray = ray, inspire = inspire {
                    spells.appendContentsOf([reflect, ray, inspire])
                }
            case "Dolo, God of Agony":
                let reflect = ObjectProvider.spellForName("Reflect")
                
                if let reflect = reflect {
                    spells.append(reflect)
                }
            case "Kazu, God of Deceit":
                let reflect = ObjectProvider.spellForName("Reflect")
                
                if let reflect = reflect {
                    spells.append(reflect)
                }
            default:
                print("Bad God?")
            }
        }
        
        return spells
    }
}
