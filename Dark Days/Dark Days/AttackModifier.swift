//
//  AttackModifier.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

enum AttackModifierType: String {
    case Melee
    case Ranged
    case Magical
    
    var image: UIImage? {
        switch self {
        case .Melee:
            return UIImage(named: "MeleeAttackModifier")
        case .Ranged:
            return UIImage(named: "RangedAttackModifier")
        case .Magical:
            return UIImage(named: "MagicalAttackModifier")
        }
    }
    
    static func attackModifierTypeForName(name: String) -> AttackModifierType {
        switch name {
        case "Melee":
            return .Melee
        case "Ranged":
            return .Ranged
        case "Magical":
            return .Magical
        default:
            return .Melee
        }
    }
}

struct AttackModifier: Decodable, Nameable {
    let name: String
    let value: Int
    
    static func decode(_ json: Any) throws -> AttackModifier {
        return try AttackModifier(name: json => "name",
                                   value: json => "value")
    }
}

extension AttackModifier {
    static let allAttackModifierTypes: [AttackModifierType] = [.Melee, .Ranged, .Magical]
    
    var attackModifierType: AttackModifierType {
        return AttackModifierType.attackModifierTypeForName(name: name)
    }
}
