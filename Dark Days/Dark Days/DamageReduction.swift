//
//  DamageReduction.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

enum DamageReduction: Decodable {
    case Physical(Int)
    case Poison(Int)
    case Fire(Int)
    case Cold(Int)
    
    static func decode(json: AnyObject) throws -> DamageReduction {
        guard let name = try json => "name" as? String else { return DamageReduction.Physical(0) }
        guard let value = try json => "value" as? Int else { return DamageReduction.Physical(0) }
        
        switch name {
        case "Physical":
            return DamageReduction.Physical(value)
        case "Poison":
            return DamageReduction.Poison(value)
        case "Fire":
            return DamageReduction.Fire(value)
        case "Cold":
            return DamageReduction.Cold(value)
        default:
            return DamageReduction.Physical(0)
        }
    }
}
