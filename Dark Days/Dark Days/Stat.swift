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
    
    var shortName: String {
        switch self {
        case .Strength:
            return "STR"
        case .Dexterity:
            return "DEX"
        case .Constitution:
            return "CON"
        case .Intelligence:
            return "INT"
        case .Faith:
            return "FAI"
        }
    }
    
    static func statTypeForString(string: String) -> StatType {
        switch string {
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
    
    static func statTypeForShortName(string: String) -> StatType {
        switch string {
        case "STR":
            return .Strength
        case "DEX":
            return .Dexterity
        case "CON":
            return .Constitution
        case "INT":
            return .Intelligence
        case "FAI":
            return .Faith
        default:
            return .Strength
        }
    }
}

final class Stat: Decodable, Nameable, Codeable, Equatable {
    typealias CoderType = StatCoder
    
    let name: String
    let shortName: String
    let explanation: String
    let benefits: [String]
    var currentValue: Int = 0
    
    var statType: StatType {
        return StatType.statTypeForString(string: name)
    }
    
    init(name: String, shortName: String, explanation: String, benefits: [String], currentValue: Int) {
        self.name = name
        self.shortName = shortName
        self.explanation = explanation
        self.benefits = benefits
        self.currentValue = currentValue
    }
    
    static func decode(_ json: Any) throws -> Stat {
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
    
    fileprivate enum Keys: String {
        case Name
        case CurrentValue
    }
    
    var value: Stat?
    
    init(value: Stat) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        let stat = ObjectProvider.statForName(name)
        stat?.currentValue = aDecoder.decodeInteger(forKey: Keys.CurrentValue.rawValue)
        
        value = stat
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encode(value?.currentValue ?? 0, forKey: Keys.CurrentValue.rawValue)
    }
}
