//
//  AttackModifier.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct AttackModifier: Decodable, Nameable {
    let name: String
    let value: Int
    
    static func decode(_ json: Any) throws -> AttackModifier {
        return try AttackModifier(name: json => "name",
                                   value: json => "value")
    }
}

extension AttackModifier {
    enum AttackModifierType: String {
        case Physical
        case Magical
        
        var image: UIImage? {
            switch self {
            case .Physical:
                return UIImage(named: "PhysicalAttackModifier")
            case .Magical:
                return UIImage(named: "MagicalAttackModifier")
            }
        }
    }
    
    static let allAttackModifierTypes: [AttackModifierType] = [.Physical, .Magical]
    
    var attackModifierType: AttackModifierType {
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
