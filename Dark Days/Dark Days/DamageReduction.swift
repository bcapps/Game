//
//  DamageReduction.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct DamageReduction: Decodable, Nameable {
    let name: String
    let value: Int
    
    static func decode(json: AnyObject) throws -> DamageReduction {
        return try DamageReduction(name: json => "name",
                                   value: json => "value")
    }
}

extension DamageReduction {
    enum ReductionType: String {
        case Physical
        case Poison
        case Fire
        case Cold
    }
    
    static let allReductionTypes: [ReductionType] = [.Physical, .Poison, .Fire, .Cold]
    
    var reductionType: ReductionType {
        switch name {
        case "Physical":
            return .Physical
        case "Poison":
            return .Poison
        case "Fire":
            return .Fire
        case "Cold":
            return .Cold
        default:
            return .Physical
        }
    }
}
