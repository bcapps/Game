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

    func testStatModifierCodingWorks() {
        guard let JSONURL = Bundle(for: type(of: self)).url(forResource: "StatModifierJSON", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: JSONURL) else { return }
        guard let JSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
        
        let itemEffect = try? StatModifier.decode(JSON)
        
        XCTAssertNotNil(itemEffect)
    }
}
