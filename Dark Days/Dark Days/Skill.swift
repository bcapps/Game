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
    typealias CoderType = SkillCoder
    
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

final class SkillCoder: NSObject, Coder {
    typealias Codeable = Skill
    
    private enum Keys: String {
        case Name
    }
    
    var value: Skill?
    
    init(value: Skill) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.skillForName(name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}
