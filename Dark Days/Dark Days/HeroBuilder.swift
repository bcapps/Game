//
//  HeroBuilder.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class HeroBuilder {
    private var name: String = ""
    private var gender: Gender = .Male
    private var skills = [Skill]()
    private var race: Race = Race(name: "", explanation: "", benefits: [])
    private var stats = [Stat]()
    
    func build() -> Hero {
        let inventory = Inventory()
        
        return Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, uniqueID: NSUUID().UUIDString)
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setGender(gender: Gender) {
        self.gender = gender
    }
    
    func addSkill(skill: Skill) {
        skills.append(skill)
    }
    
    func removeSkill(skill: Skill) {
        let index = skills.indexOf { (object) -> Bool in
            return skill.name == object.name
        }
        
        if let index = index {
            skills.removeAtIndex(index)
        }
    }
    
    func setRace(race: Race) {
        self.race = race
    }
    
    func setStatValueForStat(value: Int, stat: Stat) {
        var stat = stats.filter({$0.name == stat.name}).first
        stat?.currentValue = value
    }
}
