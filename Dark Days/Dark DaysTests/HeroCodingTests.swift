//
//  HeroCodingTests.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest
@testable import Dark_Days

class HeroCodingTests: XCTestCase {

    func testHeroCoding() {
        var inventory = Inventory()
        inventory.gold = 5000
        
        let item1 = ObjectProvider.itemForName("Longsword")
        let item2 = ObjectProvider.itemForName("Dagger")
        
        inventory.items.append(item1!)
        inventory.items.append(item2!)
        
        var stat1 = ObjectProvider.statForName("Strength")
        stat1?.currentValue = 1
        
        var stat2 = ObjectProvider.statForName("Dexterity")
        stat2?.currentValue = 2
        
        var stat3 = ObjectProvider.statForName("Constitution")
        stat3?.currentValue = 3
        
        var stat4 = ObjectProvider.statForName("Intelligence")
        stat4?.currentValue = 4
        
        var stat5 = ObjectProvider.statForName("Faith")
        stat5?.currentValue = 5
        
        let race = ObjectProvider.raceForName("Elf")
        
        let skill = ObjectProvider.skillForName("Dwarven Resilience")
        let skill2 = ObjectProvider.skillForName("Elven Accuracy")
        
        let hero = Hero(name: "Twig", gender: Gender.Male, inventory: inventory, stats: [stat1!, stat2!, stat3!, stat4!, stat5!], race: race!, skills: [skill!, skill2!])
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(HeroCoder(value: hero))
        let unarchivedHeroCoder = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? HeroCoder
        
        let sut = unarchivedHeroCoder?.value
        
        XCTAssertEqual(sut?.name, "Twig")
        XCTAssertEqual(sut?.gender, Gender.Male)
        
        XCTAssertEqual(sut?.inventory.gold, 5000)
        XCTAssertEqual(sut?.inventory.items.count, 2)
        XCTAssertEqual(sut?.inventory.items[0].name, item1?.name)
        
        XCTAssertEqual(sut?.stats.count, 5)
        XCTAssertEqual(sut?.stats[0].name, "Strength")
        XCTAssertEqual(sut?.stats[0].currentValue, 1)
        XCTAssertEqual(sut?.stats[4].currentValue, 5)
        
        XCTAssertEqual(sut?.race.name, race?.name)
        
        XCTAssertEqual(sut?.skills.count, 2)
        XCTAssertEqual(sut?.skills[0].name, "Dwarven Resilience")
    }
}
