//
//  TestHero.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class TestHero {
    static var hero: Hero {
        var inventory = Inventory()
        inventory.gold = 5000
        
        let item1 = ObjectProvider.itemForName("Longsword")
        let item2 = ObjectProvider.itemForName("Dagger")
        
        inventory.items.append(item1!)
        inventory.items.append(item2!)
        
        let stat1 = ObjectProvider.statForName("Strength")
        stat1?.currentValue = 1
        
        let stat2 = ObjectProvider.statForName("Dexterity")
        stat2?.currentValue = 2
        
        let stat3 = ObjectProvider.statForName("Constitution")
        stat3?.currentValue = 3
        
        let stat4 = ObjectProvider.statForName("Intelligence")
        stat4?.currentValue = 4
        
        let stat5 = ObjectProvider.statForName("Faith")
        stat5?.currentValue = 5
        
        let race = ObjectProvider.raceForName("Elf")
        
        let skill = ObjectProvider.skillForName("Dwarven Resilience")
        let skill2 = ObjectProvider.skillForName("Elven Accuracy")
        
        let magicType = ObjectProvider.magicTypeForName("Mundane")
        let god = ObjectProvider.godForName("Dolo, God of Agony")
        
        return Hero(name: "Twig", gender: Gender.Male, inventory: inventory, stats: [stat1!, stat2!, stat3!, stat4!, stat5!], race: race!, skills: [skill!, skill2!], magicType: magicType!, god: god!, uniqueID: NSUUID().UUIDString)
    }
}
