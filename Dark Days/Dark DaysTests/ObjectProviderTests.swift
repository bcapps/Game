//
//  ObjectProviderTests.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest
@testable import Dark_Days

class ObjectProviderTests: XCTestCase {
    func testObjectProviderProvidesObjects() {
        let gods: [God] = ObjectProvider.objectsForJSON("ObjectProviderTestJSONArray")
        
        XCTAssertEqual(gods.count, 10)
    }
    
    func testObjectProviderProvidesGods() {
        let gods: [God] = ObjectProvider.objectsForJSON("Gods")
        
        XCTAssertEqual(gods.count, 10)
    }
    
    func testObjectProviderProvidesSkills() {
        let skills: [Skill] = ObjectProvider.objectsForJSON("Skills")
        
        XCTAssertEqual(skills.count, 8)
    }
    
    func testObjectProviderProvidesItems() {
        let items: [Item] = ObjectProvider.objectsForJSON("Items")
        
        XCTAssertEqual(items.count, 19)
    }
    
    func testObjectProviderProvidesStats() {
        let stats: [Stat] = ObjectProvider.objectsForJSON("Stats")
        
        XCTAssertEqual(stats.count, 5)
    }
    
    func testObjectProviderProvidesRaces() {
        let races: [Race] = ObjectProvider.objectsForJSON("Races")
        
        XCTAssertEqual(races.count, 3)
    }
    
    func testObjectProviderProvidesTowns() {
        let towns: [Town] = ObjectProvider.objectsForJSON("Towns")
        
        XCTAssertEqual(towns.count, 2)
    }
    
    func testObjectProviderProvidesMonsters() {
        let monsters: [Monster] = ObjectProvider.objectsForJSON("Monsters")
        
        XCTAssertEqual(monsters.count, 4)
    }
    
    func testObjectProviderProvidesSpells() {
        let spells: [Spell] = ObjectProvider.objectsForJSON("Spells")
        
        XCTAssertEqual(spells.count, 10)
    }
}
