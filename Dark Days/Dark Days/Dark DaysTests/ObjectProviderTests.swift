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
}
