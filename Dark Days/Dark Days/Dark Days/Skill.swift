//
//  Skill.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Skill: Decodable, Nameable, Codeable {
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

final class SkillCoder: NSObject, Coder {
    typealias CodeableType = Skill
    
    private enum Keys: String {
        case Name
        case Explanation
        case Benefit
    }
    
    var value: Skill?
    
    init(value: Skill) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        let rawExplanation = aDecoder.decodeObjectForKey(Keys.Explanation.rawValue) as? String
        let rawBenefit = aDecoder.decodeObjectForKey(Keys.Benefit.rawValue) as? String
        
        guard let name = rawName, explanation = rawExplanation, benefit = rawBenefit else {
            value = nil
            super.init()
            
            return nil
        }
        
        value = Skill(name: name, explanation: explanation, benefit: benefit)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encodeObject(value?.explanation, forKey: Keys.Explanation.rawValue)
        aCoder.encodeObject(value?.benefit, forKey: Keys.Benefit.rawValue)
    }
}