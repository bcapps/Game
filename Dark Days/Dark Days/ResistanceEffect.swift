//
//  ResistanceEffect.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

enum ResistanceEffect: Decodable {
    case Physical(Int)
    case Poison(Int)
    case Fire(Int)
    case Cold(Int)
    
    static func decode(json: AnyObject) throws -> ResistanceEffect {
        guard let name = try json => "name" as? String else { return ResistanceEffect.Physical(0) }
        guard let value = try json => "value" as? Int else { return ResistanceEffect.Physical(0) }
        
        switch name {
        case "Physical":
            return ResistanceEffect.Physical(value)
        case "Poison":
            return ResistanceEffect.Poison(value)
        case "Fire":
            return ResistanceEffect.Fire(value)
        case "Cold":
            return ResistanceEffect.Cold(value)
        default:
            return ResistanceEffect.Physical(0)
        }
    }
}
