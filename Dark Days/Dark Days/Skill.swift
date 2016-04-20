//
//  Skill.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Skill: Decodable, Nameable, Codeable, Equatable {
    typealias CoderType = GenericCoder<Skill>
    
    let name: String
    let explanation: String
    let benefit: String
    
    static func decode(json: AnyObject) throws -> Skill {
        return try Skill(name: json => "name",
            explanation: json => "explanation",
            benefit: json => "benefit")
    }
}

func == (lhs: Skill, rhs: Skill) -> Bool {
    return lhs.name == rhs.name
}

extension Skill: Unarchiveable {
    static var JSONName: String {
        return "Skills"
    }
}
