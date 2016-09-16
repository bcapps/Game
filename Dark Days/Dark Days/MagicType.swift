//
//  MagicType.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct MagicType: Decodable, Codeable, Nameable {
    typealias CoderType = MagicTypeCoder

    let name: String
    let explanation: String
    let benefits: [String]
    
    static func decode(_ json: Any) throws -> MagicType {
        return try MagicType(name: json => "name",
            explanation: json => "explanation",
            benefits: json => "benefits")
    }
}

extension MagicType {
    enum Status: String {
        case Mundane
        case Gifted
    }
    
    var status: Status {
        switch name {
            case "Gifted":
                return .Gifted
            case "Mundane": fallthrough
            default:
                return .Mundane
        }
    }
}

final class MagicTypeCoder: NSObject, Coder {
    typealias Codeable = MagicType
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: MagicType?
    
    init(value: MagicType) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.magicTypeForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
