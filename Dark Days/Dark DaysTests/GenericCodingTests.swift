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
        let quest = Quest(name: "Spider Slayers", explanation: "Description", notes: "notes", rewards: [])
        let genericCoder = QuestCoder(value: quest)
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(genericCoder)
        let unarchivedQuestCoder = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? QuestCoder
        
        let unarchivedQuest = unarchivedQuestCoder?.value
        
        XCTAssertNotNil(unarchivedQuest)
        XCTAssertEqual(quest.name, "Spider Slayers")
    }

}
