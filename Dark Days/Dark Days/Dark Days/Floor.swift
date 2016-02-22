//
//  Floor.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Floor: Decodable, Nameable {
    let name: String
    let background: String
    let towns: [String]
    
    static func decode(json: AnyObject) throws -> Floor {
        return try Floor(name: json => "name",
            background: json => "background",
            towns: json => "towns")
    }
}

final class FloorCoder: NSObject, NSCoding {
    private enum Keys: String {
        case Name
        case Background
        case Towns
    }

    var floor: Floor?
    
    init(floor: Floor) {
        self.floor = floor
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        let rawBackground = aDecoder.decodeObjectForKey(Keys.Background.rawValue) as? String
        let rawTowns = aDecoder.decodeObjectForKey(Keys.Towns.rawValue) as? [String]
        
        guard let name = rawName, background = rawBackground, towns = rawTowns else {
            floor = nil
            super.init()
            
            return nil
        }
        
        floor = Floor(name: name, background: background, towns: towns)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(floor?.name, forKey: Keys.Name.rawValue)
        aCoder.encodeObject(floor?.background, forKey: Keys.Background.rawValue)
        aCoder.encodeObject(floor?.towns, forKey: Keys.Towns.rawValue)
    }
}