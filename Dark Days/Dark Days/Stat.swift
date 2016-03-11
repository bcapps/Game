//
//  Stats.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable


enum StatType: String {
    case Strength
    case Dexterity
    case Constitution
    case Intelligence
    case Faith
}

final class Stat: Decodable, Nameable, Codeable, Equatable {
    typealias CoderType = StatCoder
    
    let name: String
    let shortName: String
    let explanation: String
    let benefits: [String]
    var currentValue: Int = 0
    
    var statType: StatType {
        switch name {
        case "Strength":
            return .Strength
        case "Dexterity":
            return .Dexterity
        case "Constitution":
            return .Constitution
        case "Intelligence":
            return .Intelligence
        case "Faith":
            return .Faith
        default:
            return .Strength
        }
    }
    
    init(name: String, shortName: String, explanation: String, benefits: [String], currentValue: Int) {
        self.name = name
        self.shortName = shortName
        self.explanation = explanation
        self.benefits = benefits
        self.currentValue = currentValue
    }
    
    static func decode(json: AnyObject) throws -> Stat {
        return try Stat(
            name: json => "name",
            shortName: json => "shortName",
            explanation: json => "explanation",
            benefits: json => "benefits",
            currentValue: 0
        )
    }
}

func == (lhs: Stat, rhs: Stat) -> Bool {
    return lhs.name == rhs.name
}

final class StatCoder: NSObject, Coder {
    typealias Codeable = Stat
    
    private enum Keys: String {
        case Name
        case CurrentValue
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
        
        let stat = ObjectProvider.statForName(name)
        stat?.currentValue = aDecoder.decodeIntegerForKey(Keys.CurrentValue.rawValue)
        
        value = stat
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encodeInteger(value?.currentValue ?? 0, forKey: Keys.CurrentValue.rawValue)
    }
}
