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
        let optionalHero = TestHero.hero
        
        guard let hero = optionalHero else { XCTFail(); return }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: HeroCoder(value: hero))
        let unarchivedHeroCoder = NSKeyedUnarchiver.unarchiveObject(with: data) as? HeroCoder
        
        let sut = unarchivedHeroCoder?.value
        
        XCTAssertEqual(sut?.name, "Twig")
        XCTAssertEqual(sut?.gender, Gender.Male)
        
        XCTAssertEqual(sut?.inventory.gold, 5000)
        XCTAssertEqual(sut?.inventory.items.count, 2)
        XCTAssertEqual(sut?.inventory.items[0].name, "Basic Hammer")
        
        XCTAssertEqual(sut?.stats.count, 5)
        XCTAssertEqual(sut?.stats[0].name, "Strength")
        XCTAssertEqual(sut?.stats[0].currentValue, 1)
        XCTAssertEqual(sut?.stats[4].currentValue, 5)
        
        XCTAssertEqual(sut?.race.name, "Elf")
        
        XCTAssertEqual(sut?.skills.count, 2)
        XCTAssertEqual(sut?.skills[0].name, "Dwarven Resilience")
        XCTAssertEqual(sut?.god?.name, "Dolo, God of Agony")
        XCTAssertEqual(sut?.magicType.status, .Mundane)
    }
    
    func testHeroStatUpdate() {
        let optionalHero = TestHero.hero
        
        guard let hero = optionalHero else { XCTFail(); return }
        
        hero.increaseStatBy(.Strength, value: 4)
        
        XCTAssertEqual(hero.statValueForType(.Strength), 5)
    }
}
