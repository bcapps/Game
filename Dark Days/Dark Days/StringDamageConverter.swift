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
        let whitespace = CharacterSet.whitespacesAndNewlines
        
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
                } else if separatedStrings.count == 1 {
                    let range = damageWithNumberReplacement.startIndex..<damageWithNumberReplacement.endIndex

                    damageWithNumberReplacement.enumerateSubstrings(in: range, options: .reverse, { (substring, subrange, enclosingRange, stop) in
                        guard let substring = substring?.trimmingCharacters(in: whitespace) else { stop = true; return }
                        let newValue = (Int(substring) ?? 0) + (Int(separatedStrings[0]) ?? 0)
                        damageWithNumberReplacement.replaceSubrange(subrange, with: String(newValue))
                        stop = true
                    })
                } else {
                    damageWithNumberReplacement.append(substring)
                }
            } else if substring == "+" {
                continue
            } else {
                damageWithNumberReplacement.append(substring)
            }
            
            damageWithNumberReplacement.append(" ")
        }
        
        return damageWithNumberReplacement.trimmingCharacters(in: whitespace)
    }
}
