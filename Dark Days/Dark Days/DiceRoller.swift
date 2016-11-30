//
//  DiceRoller.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import GameplayKit

enum Dice: Int {
    
    case d2
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20

    static var numberOfTypesOfDice: Int {
        return 7
    }
    
    var upperValue: Int {
        switch self {
        case .d2:
            return 2
        case .d4:
            return 4
        case .d6:
            return 6
        case .d8:
            return 8
        case .d10:
            return 10
        case .d12:
            return 12
        case .d20:
            return 20
        }
    }
    
    var image: UIImage? {
        switch self {
        case .d2:
            return UIImage(named: "d2")
        case .d4:
            return UIImage(named: "d4")
        case .d6:
            return UIImage(named: "d6")
        case .d8:
            return UIImage(named: "d8")
        case .d10:
            return UIImage(named: "d10")
        case .d12:
            return UIImage(named: "d12")
        case .d20:
            return UIImage(named: "d20")
        }
    }
}

final class DiceRoller {
    
    static func roll(dice: Dice, count: Int = 1) -> Int {
        let distribution = GKRandomDistribution(forDieWithSideCount: dice.upperValue)
        
        var value = 0
        
        for _ in 0..<count {
            value += distribution.nextInt()
        }
        
        return value
    }
}
