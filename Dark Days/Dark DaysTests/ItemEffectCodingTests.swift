//
//  ItemEffectCodingTests.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest
@testable import Dark_Days

class ItemEffectCodingTests: XCTestCase {

    func testItemEffectCodingWorks() {
        guard let JSONURL = NSBundle(forClass: self.dynamicType).URLForResource("ItemEffectJSON", withExtension: "json") else { return }
        guard let data = NSData(contentsOfURL: JSONURL) else { return }
        guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) else { return }
        
        let itemEffect = try? StatEffect.decode(JSON)
        
        XCTAssertNotNil(itemEffect)
    }
}
