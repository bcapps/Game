//
//  GenericCodingTests.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/20/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest
@testable import Dark_Days

class GenericCodingTests: XCTestCase {

    func testGenericCodingWorks() {
        let quest = Quest(name: "Spider Slayers", description: "Description", rewards: [])
        let genericCoder = GenericCoder<Quest>(value: quest)
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(genericCoder)
        let unarchivedQuestCoder = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? GenericCoder<Quest>
        
        let unarchivedQuest = unarchivedQuestCoder?.value
        
        XCTAssertNotNil(unarchivedQuest)
        XCTAssertEqual(quest.name, "Spider Slayers")
    }

}
