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
    typealias CoderType = GenericCoder<MagicType>

    let name: String
    let explanation: String
    let benefits: [String]
    
    static func decode(json: AnyObject) throws -> MagicType {
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

extension MagicType: Unarchiveable {
    static var JSONName: String {
        return "MagicTypes"
    }
}
