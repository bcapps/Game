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
        let inventory = Inventory(gold: 0, items: [])
        
        if let startingItem = ObjectProvider.itemForName("Clothes") {
            startingItem.equippedSlot = .Chest
            inventory.items.append(startingItem)
        }
        
        var skills = [Skill]()
        if let skill = skill {
            skills.append(skill)
        }
        
        let spells = spellsForGod(god)
        let hero = Hero(name: name, gender: gender, inventory: inventory, stats: stats, race: race, skills: skills, spells: spells, magicType: magicType, god: god, uniqueID: NSUUID().UUIDString)
        hero.currentHealth = hero.maximumHealth
        
        return hero
    }
        
    func increaseStatValue(value: Int, type: StatType) {
        let stat = stats.filter({$0.statType == type}).first
        stat?.currentValue += value
    }
    
    private func spellsForGod(god: God?) -> [Spell] {
        var spells = [Spell]()
        
        guard let name = god?.name else { return [] }
        
        switch name {
        case "Shiro, God of Hope":
            guard let reflect = ObjectProvider.spellForName("Shield of Reflection") else { return [] }
            guard let ray = ObjectProvider.spellForName("Siphon Light") else { return [] }
            guard let inspire = ObjectProvider.spellForName("Inspire") else { return [] }
            
            spells.appendContentsOf([reflect, ray, inspire])
        case "Dolo, God of Agony":
            guard let bond = ObjectProvider.spellForName("Agonizing Bond") else { return [] }
            guard let fiendfyre = ObjectProvider.spellForName("Fiendfyre") else { return [] }
            guard let thornbind = ObjectProvider.spellForName("Thorn Bind") else { return [] }
            
            spells.appendContentsOf([bond, fiendfyre, thornbind])
        case "Kazu, God of Deceit":
            guard let blind = ObjectProvider.spellForName("Blind") else { return [] }
            guard let stalker = ObjectProvider.spellForName("Shadow Stalker") else { return [] }
            guard let paranoia = ObjectProvider.spellForName("Paranoia") else { return [] }
            
            spells.appendContentsOf([blind, stalker, paranoia])
        default:
            print("Bad God?")
        }
        
        return spells
    }
}
