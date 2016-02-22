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
    }
    
    var value: Stat?
    
    init(value: Stat) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        
        guard let name = rawName else {
            value = nil
            
            super.init()
            return nil
        }
        
        value = ObjectProvider.statForName(name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}