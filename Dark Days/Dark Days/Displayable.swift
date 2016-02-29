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
        
        return ListDisplayable(title: object.name, information: information, additionalInfoTitle: nil, additionalInfo: nil, subtext: subtext, image: object.race.image)
    }
}

extension Race: ListDisplayingGeneratable {
    static func displayable(race: Race) -> ListDisplayable {
        return ListDisplayable(title: race.name, information: race.explanation, additionalInfoTitle: "Benefits", additionalInfo: race.benefits.joinWithSeparator("\n"), subtext: nil, image: race.image)
    }
}

extension Item: ListDisplayingGeneratable {
    static func displayable(item: Item) -> ListDisplayable {
        return ListDisplayable(title: item.name, information: item.damage, additionalInfoTitle: nil, additionalInfo: item.effects, subtext: item.flavor, image: UIImage(named: item.name))
    }
}

extension Skill: ListDisplayingGeneratable {
    static func displayable(skill: Skill) -> ListDisplayable {
        return ListDisplayable(title: skill.name, information: skill.benefit, additionalInfoTitle: nil, additionalInfo: nil, subtext: skill.explanation, image: UIImage(named: skill.name))
    }
}

extension Stat: ListDisplayingGeneratable {
    static func displayable(stat: Stat) -> ListDisplayable {
        return ListDisplayable(title: stat.name, information: stat.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: stat.benefits.joinWithSeparator("\n"), image: UIImage(named: stat.name))
    }
}

extension MagicType: ListDisplayingGeneratable {
    static func displayable(magicType: MagicType) -> ListDisplayable {
        return ListDisplayable(title: magicType.name, information: magicType.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: magicType.benefits.joinWithSeparator("\n"), image: UIImage(named: magicType.name))
    }
}

extension Spell: ListDisplayingGeneratable {
    static func displayable(spell: Spell) -> ListDisplayable {
        var damage = spell.damage
        if damage.characters.count > 0 {
            damage = "Damage: " + spell.damage
        }
        
        return ListDisplayable(title: spell.name, information: damage, additionalInfoTitle: nil, additionalInfo: spell.effects, subtext: spell.flavor, image: UIImage(named: spell.name))
    }
}

extension God: ListDisplayingGeneratable {
    static func displayable(god: God) -> ListDisplayable {
        return ListDisplayable(title: god.name, information: god.background, additionalInfoTitle: "Responsibilities", additionalInfo: god.responsibilties.joinWithSeparator("\n"), subtext: nil, image: UIImage(named: god.name))
    }
}

struct ListDisplayable {
    let title: String?
    let information: String?
    let additionalInfoTitle: String?
    let additionalInfo: String?
    let subtext: String?
    let image: UIImage?
    
    static func displayableObjects<T: ListDisplayingGeneratable>(objects: [T]) -> [ListDisplayable] {
        var displayableObjects = [ListDisplayable]()
        
        for object in objects {
            displayableObjects.append(T.displayable(object))
        }
        
        return displayableObjects
    }
    
    static func displayableObject<T: ListDisplayingGeneratable>(object: T) -> ListDisplayable {
        return T.displayable(object)
    }
}

extension ListDisplayable {
    
//    return ListDisplayable(title: spell.name, information: spell.damage, additionalInfoTitle: nil, additionalInfo: spell.effects, subtext: spell.flavor, image: UIImage(named: spell.name))

    var attributedString: NSAttributedString {
        get {
            let attributedString = NSMutableAttributedString()
            
            if let information = information where information.characters.count > 0 {
                let info = NSAttributedString.attributedStringWithBodyAttributes(information)
                
                attributedString.appendAttributedString(info)
                attributedString.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            if let additionalInfo = additionalInfo where additionalInfo.characters.count > 0 {

                if let title = additionalInfoTitle where title.characters.count > 0 {
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))

                    let attributedTitle = NSAttributedString.attributedStringWithHeadingAttributes(title)
                    attributedString.appendAttributedString(attributedTitle)
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
                }
                else if information?.characters.count > 0 {
                    attributedString.appendAttributedString(NSAttributedString(string: "\n"))
                }
                
                let additionalInfo = NSAttributedString.attributedStringWithBodyAttributes(additionalInfo)
                
                attributedString.appendAttributedString(additionalInfo)
            }
            
            if let subtext = subtext where subtext.characters.count > 0 {
                attributedString.appendAttributedString(NSAttributedString(string: "\n"))
                
                let subtext = NSAttributedString.attributedStringWithSmallAttributes(subtext)
                attributedString.appendAttributedString(subtext)
            }
            
            return attributedString
        }
    }
}
