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
        var sut = Inventory()
        
        let item = Item(name: "Longsword", damage: "Damage", effects: "Effects", flavor: "Flavor", itemSlot: ItemSlot.Helmet, twoHanded: false, equipped: false)
        
        sut.items.append(item)
        sut.gold = 5000
        
        let ic = InventoryCoder(value: sut)
        let data = NSKeyedArchiver.archivedDataWithRootObject(ic)
        let unarchivedIC = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? InventoryCoder
        
        let inventory = unarchivedIC?.value
        let firstItem = inventory?.items.first
        
        XCTAssertEqual(inventory?.gold, 5000)
        XCTAssertEqual(firstItem?.name, "Longsword")
    }
}
