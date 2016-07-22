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
        case Magical
        case Poison
        case Fire
        case Cold
        case Lightning
        
        var image: UIImage? {
            switch self {
            case .Physical:
                return UIImage(named: "PhysicalDamageReduction")
            case .Poison:
                return UIImage(named: "PoisonDamageReduction")
            case .Fire:
                return UIImage(named: "FireDamageReduction")
            case .Cold:
                return UIImage(named: "ColdDamageReduction")
            case .Lightning:
                return UIImage(named: "LightningDamageReduction")
            case .Magical:
                return UIImage(named: "MagicalDamageReduction")
            }
        }
    }
    
    static let allReductionTypes: [ReductionType] = [.Physical, .Magical, .Poison, .Fire, .Cold, .Lightning]
    
    var reductionType: ReductionType {
        switch name {
        case "Physical":
            return .Physical
        case "Magical":
            return .Magical
        case "Poison":
            return .Poison
        case "Fire":
            return .Fire
        case "Cold":
            return .Cold
        case "Lightning":
            return .Lightning
        default:
            return .Physical
        }
    }
}
