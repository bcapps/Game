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
    func testObjectProviderProvidesObject() {
        let god: God? = ObjectProvider.objectForJSON("ObjectProviderTestJSONDictionary")
        
        XCTAssertNotNil(god)
    }

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
        
        XCTAssertEqual(skills.count, 2)
    }
    
    func testObjectProviderProvidesItems() {
        let items: [Item] = ObjectProvider.objectsForJSON("Items")
        
        XCTAssertEqual(items.count, 2)
    }
    
    func testObjectProviderProvidesStats() {
        let stats: [Stat] = ObjectProvider.objectsForJSON("Stats")
        
        XCTAssertEqual(stats.count, 5)
    }
    
    func testObjectProviderProvidesRaces() {
        let races: [Race] = ObjectProvider.objectsForJSON("Races")
        
        XCTAssertEqual(races.count, 3)
    }
}
