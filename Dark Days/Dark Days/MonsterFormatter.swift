//
//  MonsterFormatter.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class MonsterFormatter {
    
    static func formatMonsters() -> [String] {
        let monsters: [Monster] = ObjectProvider.objectsForJSON("Monsters").sorted { $0.name < $1.name }
        
        var formattedStrings: [String] = []
        
        for monster in monsters {
            var string = "\n" + "___" + "\n"
            string += "> ## " + monster.name + "\n"
            string += ">*" + monster.type + "*" + "\n"
            string += "> ___" + "\n"
            string += "> - **Hit Points** " + String(monster.health) + "\n"
            string += "> - **Speed** " + monster.speed + "\n"
            string += ">___" + "\n"
            string += ">|STR|DEX|CON|INT|FAI|" + "\n"
            string += ">|:---:|:---:|:---:|:---:|:---:|:---:|" + "\n"
            string += "|" + monster.stats.flatMap({ String($0.value) }).joined(separator: "|") + "|" + "\n"
            string += ">___" + "\n"
            string += "> - **Damage Immunities** " + monster.damageImmunities.joined(separator: ", ") + "\n"
            string += "> - **Condition Immunities** " + monster.conditionImmunities.joined(separator: ", ") + "\n"
            string += "> - **Languages** " + monster.languages.joined(separator: ", ") + "\n"
            string += "> ___" + "\n"
            string += monster.traits.flatMap {
                let explanation = $0.explanation.replacingOccurrences(of: "[%name%]", with: monster.name)

                return "> ***" + $0.name + "*** " + explanation
            }.joined(separator: "\n>\n") + "\n"
            string += "> ### Actions" + "\n"
            string += monster.attacks.flatMap { "> ***" + $0.name + "*** " + $0.attack.damageText }.joined(separator: "\n>\n")
            
            formattedStrings.append(string + "\n")
        }
        
        return formattedStrings
    }
}
