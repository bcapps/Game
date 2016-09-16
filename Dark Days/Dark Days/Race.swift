//
//  Race.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Race: Decodable, Nameable, Codeable {
    typealias CoderType = RaceCoder
    
    let name: String
    let explanation: String
    let benefits: [String]
    
    static func decode(_ json: Any) throws -> Race {
        return try Race(
            name: json => "name",
            explanation: json => "explanation",
            benefits: json => "benefits")
    }
}

extension Race {
    enum RaceType: String {
        case Human
        case Dwarf
        case Elf
    }
    
    var raceType: RaceType {
        get {
            if self.name == "Dwarf" {
                return .Dwarf
            } else if self.name == "Elf" {
                return .Elf
            }
            
            return .Human
        }
    }
    
    func imageForGender(_ gender: Gender) -> UIImage {
        return UIImage(named: name + gender.rawValue) ?? UIImage()
    }
}

final class RaceCoder: NSObject, Coder {
    typealias CodeableType = Race
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: Race?
    
    init(value: Race) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.raceForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
