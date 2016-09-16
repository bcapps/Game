//
//  DamageAvoidance.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/3/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct DamageAvoidance: Decodable, Nameable {
    let name: String
    let value: Int
    
    static func decode(_ json: Any) throws -> DamageAvoidance {
        return try DamageAvoidance(name: json => "name",
                                   value: json => "value")
    }
}

extension DamageAvoidance {
    enum AvoidanceType: String {
        case Physical
        case Magical
        case Mental
        
        var image: UIImage? {
            switch self {
            case .Physical:
                return UIImage(named: "PhysicalDamageAvoidance")
            case .Magical:
                return UIImage(named: "MagicalDamageAvoidance")
            case .Mental:
                return UIImage(named: "MentalDamageAvoidance")
            }
        }
    }
    
    static let allAvoidanceTypes: [AvoidanceType] = [.Physical, .Magical, .Mental]
    
    var avoidanceType: AvoidanceType {
        switch name {
        case "Physical":
            return .Physical
        case "Magical":
            return .Magical
        case "Mental":
            return .Mental
        default:
            return .Physical
        }
    }
}
