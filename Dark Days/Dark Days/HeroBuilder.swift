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
                
        return Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, magicType: magicType, god: god, uniqueID: NSUUID().UUIDString)
    }
        
    func setStatValueForStat(value: Int, stat: Stat) {
        var stat = stats.filter({$0.name == stat.name}).first
        stat?.currentValue = value
    }
}
