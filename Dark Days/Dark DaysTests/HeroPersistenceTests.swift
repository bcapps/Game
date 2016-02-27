//
//  HeroPersistenceTests.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest

class HeroPersistenceTests: XCTestCase {

    func testHeroPersistence() {
        let sut = HeroPersistence(persistenceFilename: "TestHeroes")
        let hero = TestHero.hero
        
        XCTAssertEqual(sut.allPersistedHeroes().count, 0)
        
        sut.persistHero(hero)
        
        XCTAssertEqual(sut.allPersistedHeroes().count, 1)
        
        let testHero = sut.allPersistedHeroes().first
        
        XCTAssertEqual(hero.name, testHero?.name)
        XCTAssertEqual(hero.uniqueID, testHero?.uniqueID)
        
        sut.removeHero(hero)
        
        XCTAssertEqual(sut.allPersistedHeroes().count, 0)
    }

}
