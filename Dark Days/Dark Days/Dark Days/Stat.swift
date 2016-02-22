//
//  Stats.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Stat: Decodable, Nameable, Codeable {
    typealias CoderType = StatCoder
    
    let name: String
    let shortName: String
    let explanation: String
    let benefits: [String]
    
    static func decode(json: AnyObject) throws -> Stat {
        return try Stat(
            name: json => "name",
            shortName: json => "shortName",
            explanation: json => "explanation",
            benefits: json => "benefits"
        )
    }
}

final class StatCoder: NSObject, Coder {
    typealias Codeable = Stat
    
    private enum Keys: String {
        case Name
        case ShortName
        case Explanation
        case Benefits
    }
    
    var value: Stat?
    
    init(value: Stat) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        let rawShortName = aDecoder.decodeObjectForKey(Keys.ShortName.rawValue) as? String
        let rawExplanation = aDecoder.decodeObjectForKey(Keys.Explanation.rawValue) as? String
        let rawBenefits = aDecoder.decodeObjectForKey(Keys.Benefits.rawValue) as? [String]
        
        guard let name = rawName, shortName = rawShortName, explanation = rawExplanation, benefits = rawBenefits else {
            value = nil
            
            super.init()
            return nil
        }
        
        value = Stat(name: name, shortName: shortName, explanation: explanation, benefits: benefits)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encodeObject(value?.shortName, forKey: Keys.ShortName.rawValue)
        aCoder.encodeObject(value?.explanation, forKey: Keys.Explanation.rawValue)
        aCoder.encodeObject(value?.benefits, forKey: Keys.Benefits.rawValue)
    }
}