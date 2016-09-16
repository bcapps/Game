//
//  DamageModifier.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/20/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct DamageModifier: Decodable, Nameable {
    let name: String
    let value: Int
    
    static func decode(_ json: Any) throws -> DamageModifier {
        return try DamageModifier(name: json => "name",
                                  value: json => "value")
    }
}

extension DamageModifier {
    enum DamageModifierType: String {
        case Physical
        case Magical
        
        var image: UIImage? {
            switch self {
            case .Physical:
                return UIImage(named: "PhysicalDamageModifier")
            case .Magical:
                return UIImage(named: "MagicalDamageModifier")
            }
        }
    }
    
    static let allDamageModifierTypes: [DamageModifierType] = [.Physical, .Magical]
    
    var attackModifierType: DamageModifierType {
        switch name {
        case "Physical":
            return .Physical
        case "Magical":
            return .Magical
        default:
            return .Physical
        }
    }
}
