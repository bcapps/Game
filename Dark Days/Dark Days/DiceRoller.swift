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
    
    static func diceForUpperValue(value: Int) -> Dice {
        switch value {
        case 2:
            return .d2
        case 4:
            return .d4
        case 6:
            return .d6
        case 8:
            return .d8
        case 10:
            return .d10
        case 12:
            return .d12
        case 20:
            return .d20
        default:
            return .d2
        }
    }
}

final class DiceRoller {
    
    struct RollResult {
        let naturalAttackRoll: Int
        let attackRoll: Int
        let damageRoll: Int
        
        var isNatural20: Bool {
            return naturalAttackRoll == 20
        }
        
        var isNatural1: Bool {
            return naturalAttackRoll == 1
        }
        
        var attackRollText: String {
            let baseString = String(format: "Attack Roll: %@", String(attackRoll))
            if isNatural20 {
                return baseString + " (Natural 20!)"
            } else if isNatural1 {
                return baseString + " (Natural 1!)"
            }
            
            return baseString
        }
        
        var damageRollText: String {
            return String(format: "Damage: %@", String(damageRoll))
        }
    }
    
    static func rollNonDamageAttack(forHero hero: Hero, attackType: AttackModifierType) -> RollResult {
        let attackDiceRoll = DiceRoller.roll(dice: .d20)
        let heroAttackModifier = hero.attackModifier(forAttackType: attackType)
        
        let combinedAttackRoll = attackDiceRoll + heroAttackModifier
        
        return RollResult(naturalAttackRoll: attackDiceRoll, attackRoll: combinedAttackRoll, damageRoll: 0)
    }
    
    static func rollAttack(forHero hero: Hero, attack: Attack) -> RollResult {
        let attackDiceRoll = DiceRoller.roll(dice: .d20)
        let heroAttackModifier = hero.attackModifier(forAttackType: attack.attackType)
        
        let combinedAttackRoll = attackDiceRoll + heroAttackModifier
        
        let dice = Dice.diceForUpperValue(value: attack.damageDiceValue)
        let damageModifierType: DamageModifier.DamageModifierType = (attack.attackType == .Melee || attack.attackType == .Ranged) ? .Physical : .Magical
        let heroDamageModifier = hero.damageModifier(forAttack: attack, modifierType: damageModifierType)
        
        var damage: Int = 0
        
        switch attackDiceRoll {
        case 20:
            damage = maxRoll(dice: dice, count: attack.damageDiceNumber) + heroDamageModifier + (attack.additionalDamage ?? 0)
        default:
            damage = roll(dice: dice, count: attack.damageDiceNumber) + (attack.additionalDamage ?? 0) + heroDamageModifier
        }
        
        return RollResult(naturalAttackRoll: attackDiceRoll, attackRoll: combinedAttackRoll, damageRoll: damage)
    }
    
    static func rollAttack(forMonster monster: Monster, attack: Attack) -> RollResult {
        let attackDiceRoll = DiceRoller.roll(dice: .d20)
        let attackModifier = monster.attackModifier(forAttackType: attack.attackType)
        let combinedAttackRoll = attackDiceRoll + attackModifier
        
        let dice = Dice.diceForUpperValue(value: attack.damageDiceValue)
        let damageModifier = monster.damageModifier(forAttack: attack)
        
        var damage: Int = 0
        
        switch attackDiceRoll {
        case 20:
            damage = DiceRoller.maxRoll(dice: dice, count: attack.damageDiceNumber) + damageModifier
        default:
            damage = roll(dice: dice, count: attack.damageDiceNumber) + damageModifier
        }
        
        return RollResult(naturalAttackRoll: attackDiceRoll, attackRoll: combinedAttackRoll, damageRoll: damage)
    }
    
    static func maxRoll(dice: Dice, count: Int = 1) -> Int {
        return dice.upperValue * count
    }
    
    static func roll(dice: Dice, count: Int = 1) -> Int {
        let distribution = GKRandomDistribution(forDieWithSideCount: dice.upperValue)
        
        var value = 0
        
        for _ in 0..<count {
            value += distribution.nextInt()
        }
        
        return value
    }
}
