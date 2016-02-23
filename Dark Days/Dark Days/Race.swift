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
    
    static func decode(json: AnyObject) throws -> Race {
        return try Race(
            name: json => "name",
            explanation: json => "explanation",
            benefits: json => "benefits")
    }
}

extension Race {
    var image: UIImage {
        return UIImage(named: "Elf") ?? UIImage()
    }
}

final class RaceCoder: NSObject, Coder {
    typealias CodeableType = Race
    
    private enum Keys: String {
        case Name
    }
    
    var value: Race?
    
    init(value: Race) {
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
        
        value = ObjectProvider.raceForName(name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}