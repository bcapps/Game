//
//  God.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct God: Decodable, Nameable, Codeable {
    typealias CoderType = GodCoder

    let name: String
    let background: String
    let responsibilties: [String]
    
    static func decode(_ json: Any) throws -> God {
        return try God(
            name: json => "name",
            background: json => "background",
            responsibilties: json => "responsibilities"
        )
    }
}

final class GodCoder: NSObject, Coder {
    typealias Codeable = God
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: God?
    
    init(value: God) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.godForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
