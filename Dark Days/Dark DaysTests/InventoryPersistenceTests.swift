//
//  InventoryPersistenceTests.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest

@testable import Dark_Days

class InventoryPersistenceTests: XCTestCase {
    func testInventoryPersistence() {
        let sut = Inventory(gold: 0, items: [Item]())
        
        let item = Item(name: "Basic Hammer", damage: "Damage", effects: "Effects", flavor: "Flavor", itemSlot: ItemSlot.Helmet, twoHanded: false, statModifiers: [], damageReductions: [], damageAvoidances: [], attackModifiers: [], damageModifiers: [])
        
        sut.items.append(item)
        sut.gold = 5000
        
        let ic = InventoryCoder(value: sut)
        let data = NSKeyedArchiver.archivedData(withRootObject: ic)
        let unarchivedIC = NSKeyedUnarchiver.unarchiveObject(with: data) as? InventoryCoder
        
        let inventory = unarchivedIC?.value
        let firstItem = inventory?.items.first
        
        XCTAssertEqual(inventory?.gold, 5000)
        XCTAssertEqual(firstItem?.name, "Basic Hammer")
    }
}
