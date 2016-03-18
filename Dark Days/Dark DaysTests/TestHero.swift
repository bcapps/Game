//
//  TestHero.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class TestHero {
    static var hero: Hero? {
        let inventory = Inventory(gold: 0, items: [Item]())
        inventory.gold = 5000
        
        let optionalItem1 = ObjectProvider.itemForName("Basic Mace")
        let optionalItem2 = ObjectProvider.itemForName("Basic Dagger")
        
        let optionalStat1 = ObjectProvider.statForName("Strength")
        optionalStat1?.currentValue = 1
        
        let optionalStat2 = ObjectProvider.statForName("Dexterity")
        optionalStat2?.currentValue = 2
        
        let optionalStat3 = ObjectProvider.statForName("Constitution")
        optionalStat3?.currentValue = 3
        
        let optionalStat4 = ObjectProvider.statForName("Intelligence")
        optionalStat4?.currentValue = 4
        
        let optionalStat5 = ObjectProvider.statForName("Faith")
        optionalStat5?.currentValue = 5
        
        let optionalRace = ObjectProvider.raceForName("Elf")
        
        let optionalSkill = ObjectProvider.skillForName("Dwarven Resilience")
        let optionalSkill2 = ObjectProvider.skillForName("Elven Accuracy")
        
        let optionalSpell = ObjectProvider.spellForName("Blind")
        let optionalSpell2 = ObjectProvider.spellForName("Paranoia")
        
        let optionalMagicType = ObjectProvider.magicTypeForName("Mundane")
        let optionalGod = ObjectProvider.godForName("Dolo, God of Agony")
        
        guard let item1 = optionalItem1, item2 = optionalItem2, stat1 = optionalStat1, stat2 = optionalStat2, stat3 = optionalStat3, stat4 = optionalStat4, stat5 = optionalStat5, race = optionalRace, skill = optionalSkill, skill2 = optionalSkill2, spell = optionalSpell, spell2 = optionalSpell2, magicType = optionalMagicType, god = optionalGod else {
            
            return nil
        }
        
        inventory.items.append(item1)
        inventory.items.append(item2)
        
        return Hero(name: "Twig", gender: Gender.Male, inventory: inventory, stats: [stat1, stat2, stat3, stat4, stat5], race: race, skills: [skill, skill2], spells: [spell, spell2], magicType: magicType, god: god, uniqueID: NSUUID().UUIDString)
    }
}
