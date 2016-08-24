//
//  MonsterTrait.swift
//  Dark Days
//
//  Created by Andrew Harrison on 8/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct MonsterTrait: Decodable, Nameable {
    let name: String
    let explanation: String
    
    static func decode(json: AnyObject) throws -> MonsterTrait {
        return try MonsterTrait(name: json => "name",
                                 explanation: json => "explanation")
    }
}
