//
//  Displayable.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ListDisplayingGeneratable {
    static func displayable(object: Self) -> ListDisplayable
}

extension Hero: ListDisplayingGeneratable {
    static func displayable(object: Hero) -> ListDisplayable {
        var subtext = object.magicType.name
        
        if let godName = object.god?.name {
            subtext.appendContentsOf(": " + godName)
        }
        
        let information = object.gender.rawValue + " " + object.race.name
        
        return ListDisplayable(title: object.name, information: information, additionalInfoTitle: nil, additionalInfo: nil, subtext: subtext, image: object.race.imageForGender(object.gender), accessoryImage: nil)
    }
}

extension Race: ListDisplayingGeneratable {
    static func displayable(race: Race) -> ListDisplayable {
        return ListDisplayable(title: race.name, information: race.explanation, additionalInfoTitle: "Benefits", additionalInfo: race.benefits.joinWithSeparator("\n"), subtext: nil, image: race.imageForGender(.Male), accessoryImage: nil)
    }
}

extension Item: ListDisplayingGeneratable {
    static func displayable(item: Item) -> ListDisplayable {
        return ListDisplayable(title: item.name, information: item.damage, additionalInfoTitle: nil, additionalInfo: item.effects, subtext: item.flavor, image: UIImage(named: item.name), accessoryImage: item.imageForItemType)
    }
}

extension Skill: ListDisplayingGeneratable {
    static func displayable(skill: Skill) -> ListDisplayable {
        return ListDisplayable(title: skill.name, information: skill.benefit, additionalInfoTitle: nil, additionalInfo: nil, subtext: skill.explanation, image: UIImage(named: skill.name), accessoryImage: nil)
    }
}

extension Stat: ListDisplayingGeneratable {
    static func displayable(stat: Stat) -> ListDisplayable {
        return ListDisplayable(title: stat.name, information: stat.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: stat.benefits.joinWithSeparator("\n"), image: UIImage(named: stat.name), accessoryImage: nil)
    }
}

extension MagicType: ListDisplayingGeneratable {
    static func displayable(magicType: MagicType) -> ListDisplayable {
        return ListDisplayable(title: magicType.name, information: magicType.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: magicType.benefits.joinWithSeparator("\n"), image: UIImage(named: magicType.name), accessoryImage: nil)
    }
}

extension Spell: ListDisplayingGeneratable {
    static func displayable(spell: Spell) -> ListDisplayable {
        var damage = spell.damage
        if damage.isNotEmpty {
            damage = "Damage: " + spell.damage
        }
        
        return ListDisplayable(title: spell.name, information: damage, additionalInfoTitle: nil, additionalInfo: spell.effects, subtext: spell.flavor, image: UIImage(named: spell.name), accessoryImage: nil)
    }
}

extension God: ListDisplayingGeneratable {
    static func displayable(god: God) -> ListDisplayable {
        return ListDisplayable(title: god.name, information: god.background, additionalInfoTitle: "Responsibilities", additionalInfo: god.responsibilties.joinWithSeparator("\n"), subtext: nil, image: UIImage(named: god.name), accessoryImage: nil)
    }
}

extension Monster: ListDisplayingGeneratable {
    static func displayable(monster: Monster) -> ListDisplayable {
        let monsterAttackDescriptions = monster.attacks.map { return $0.name + ": " + $0.damage }
        
        return ListDisplayable(title: monster.name + " " + "(\(monster.health))", information: nil, additionalInfoTitle: nil, additionalInfo: monsterAttackDescriptions.joinWithSeparator("\n"), subtext: monster.explanation, image: UIImage(named: monster.name), accessoryImage: nil)
    }
}

extension Floor: ListDisplayingGeneratable {
    static func displayable(floor: Floor) -> ListDisplayable {
        return ListDisplayable(title: floor.name, information: floor.background, additionalInfoTitle: "Towns", additionalInfo: floor.towns.joinWithSeparator("\n"), subtext: nil, image: nil, accessoryImage: nil)
    }
}

extension MonsterAttack: ListDisplayingGeneratable {
    static func displayable(attack: MonsterAttack) -> ListDisplayable {
        return ListDisplayable(title: attack.name, information: attack.damage, additionalInfoTitle: nil, additionalInfo: nil, subtext: nil, image: nil, accessoryImage: nil)
    }
}

extension Quest: ListDisplayingGeneratable {
    static func displayable(quest: Quest) -> ListDisplayable {
        return ListDisplayable(title: quest.name, information: quest.explanation, additionalInfoTitle: "DM Notes", additionalInfo: quest.notes, subtext: quest.rewards.joinWithSeparator("\n"), image: nil, accessoryImage: nil)
    }
}

struct ListDisplayable {
    let title: String?
    let information: String?
    let additionalInfoTitle: String?
    let additionalInfo: String?
    let subtext: String?
    let image: UIImage?
    let accessoryImage: UIImage?
    
    static func displayableObjects<T: ListDisplayingGeneratable>(objects: [T]) -> [ListDisplayable] {
        return objects.map { return T.displayable($0) }
    }
    
    static func displayableObject<T: ListDisplayingGeneratable>(object: T) -> ListDisplayable {
        return T.displayable(object)
    }
}

extension ListDisplayable {
    
    var attributedString: NSAttributedString {
        get {
            let attributedString = NSMutableAttributedString()
            
            if let title = title where !title.isEmpty {
                let title = NSAttributedString.attributedStringWithHeadingAttributes(title)
                
                attributedString.appendAttributedString(title)
                attributedString.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            if let information = information where !information.isEmpty {
                let info = NSAttributedString.attributedStringWithBodyAttributes(information)
                
                attributedString.appendAttributedString(info)
                attributedString.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            if let additionalInfo = additionalInfo where !additionalInfo.isEmpty {

                if let title = additionalInfoTitle where !title.isEmpty {
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))

                    let attributedTitle = NSAttributedString.attributedStringWithSubHeadingAttributes(title)
                    attributedString.appendAttributedString(attributedTitle)
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
                } else if information?.isEmpty == false {
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
                }
                
                let additionalInfo = NSAttributedString.attributedStringWithBodyAttributes(additionalInfo)
                
                attributedString.appendAttributedString(additionalInfo)
                
                if let subtext = subtext where !subtext.isEmpty {
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
                }
            }
            
            if let subtext = subtext where !subtext.isEmpty {
                let subtext = NSAttributedString.attributedStringWithSmallAttributes(subtext)
                attributedString.appendAttributedString(subtext)
            }
            
            return attributedString
        }
    }
}
