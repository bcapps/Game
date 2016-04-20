//
//  ItemCodingTests.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest
@testable import Dark_Days

class ItemCodingTests: XCTestCase {

    func testItemReceivesLatestCopy() {
        let item = Item(name: "Basic Hammer", damage: "Damage", effects: "Effects", flavor: "Flavor", itemSlot: ItemSlot.Helmet, twoHanded: true, statEffects: [], damageReductions: [], damageAvoidances: [], attackModifiers: [], damageModifiers: [])
                
        let data = NSKeyedArchiver.archivedDataWithRootObject(ItemCoder(value: item))
        let unarchivedItemCoder = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ItemCoder
        
        let unarchivedItem = unarchivedItemCoder?.value
        
        XCTAssertNotNil(unarchivedItem)
        
        XCTAssertEqual(unarchivedItem?.name, "Basic Hammer")
        XCTAssertEqual(unarchivedItem?.damage, "1d4 + [STR]")
        XCTAssertEqual(unarchivedItem?.effects, "")
        XCTAssertEqual(unarchivedItem?.flavor, "A light hammer used for bludgeoning.")
        XCTAssertEqual(unarchivedItem?.itemSlot, ItemSlot.Hand)
        XCTAssertEqual(unarchivedItem?.twoHanded, false)
        XCTAssertEqual(unarchivedItem?.equippedSlot, EquipmentButton.EquipmentSlot.None)
    }
}
