//
//  StringDamageConverter.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/30/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import GameplayKit

extension String {
    
    func replaceDamageStringWithRealDamage() -> String {
        var damageWithNumberReplacement = String()
        let digits = CharacterSet.decimalDigits
        
        for substring in self.components(separatedBy: " ") {
            let decimalRange = substring.rangeOfCharacter(from: digits, options: NSString.CompareOptions(), range: nil)
            
            if decimalRange != nil {
                let separatedStrings = substring.components(separatedBy: "d")
                
                if separatedStrings.count == 2 {
                    let damageDiceString = separatedStrings[0]
                    let damageRollString = separatedStrings[1]
                    
                    if let damageDice = Int(damageDiceString), let damageRoll = Int(damageRollString) {
                        var totalDamage = 0
                        
                        let damageRandomizer = GKRandomDistribution(forDieWithSideCount: damageRoll)
                        
                        for _ in 1...damageDice {
                            totalDamage += damageRandomizer.nextInt()
                        }
                        
                        damageWithNumberReplacement.append("\(totalDamage)")
                    }
                } else {
                    damageWithNumberReplacement.append(substring)
                }
            } else {
                damageWithNumberReplacement.append(substring)
            }
            
            damageWithNumberReplacement.append(" ")
        }
        
        return damageWithNumberReplacement
    }
}
