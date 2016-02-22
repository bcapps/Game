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
        let item = Item(name: "Longsword", damage: "Damage", effects: "Effects", flavor: "Flavor", itemSlot: ItemSlot.Helmet)
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(ItemCoder(value: item))
        let unarchivedItemCoder = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ItemCoder
        
        let unarchivedItem = unarchivedItemCoder?.value
        
        XCTAssertEqual(unarchivedItem?.name, "Longsword")
        XCTAssertEqual(unarchivedItem?.damage, "1d6 + [STR]")
        XCTAssertEqual(unarchivedItem?.effects, "")
        XCTAssertEqual(unarchivedItem?.flavor, "A generic longsword. It looks like it may have seen some use.")
        XCTAssertEqual(unarchivedItem?.itemSlot, ItemSlot.itemSlotForItemString("onehand"))
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
