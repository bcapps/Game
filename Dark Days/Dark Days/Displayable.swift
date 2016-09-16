//
//  Displayable.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ListDisplayingGeneratable {
    static func displayable(_ object: Self) -> ListDisplayable
}

extension Hero: ListDisplayingGeneratable {
    static func displayable(_ object: Hero) -> ListDisplayable {
        var subtext = object.magicType.name
        
        if let godName = object.god?.name {
            subtext.append(": " + godName)
        }
        
        let information = object.gender.rawValue + " " + object.race.name
        
        return ListDisplayable(title: object.name, information: information, additionalInfoTitle: nil, additionalInfo: nil, subtext: subtext, image: object.race.imageForGender(object.gender), accessoryImage: nil)
    }
}

extension Race: ListDisplayingGeneratable {
    static func displayable(_ race: Race) -> ListDisplayable {
        return ListDisplayable(title: race.name, information: race.explanation, additionalInfoTitle: "Benefits", additionalInfo: race.benefits.joined(separator: "\n"), subtext: nil, image: race.imageForGender(.Male), accessoryImage: nil)
    }
}

extension Item: ListDisplayingGeneratable {
    static func displayable(_ item: Item) -> ListDisplayable {
        return ListDisplayable(title: item.name, information: item.damage, additionalInfoTitle: nil, additionalInfo: item.effects, subtext: item.flavor, image: UIImage(named: item.name), accessoryImage: item.imageForItemType)
    }
}

extension Skill: ListDisplayingGeneratable {
    static func displayable(_ skill: Skill) -> ListDisplayable {
        return ListDisplayable(title: skill.name, information: skill.benefit, additionalInfoTitle: nil, additionalInfo: nil, subtext: skill.explanation, image: UIImage(named: skill.name), accessoryImage: nil)
    }
}

extension Stat: ListDisplayingGeneratable {
    static func displayable(_ stat: Stat) -> ListDisplayable {
        return ListDisplayable(title: stat.name, information: stat.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: stat.benefits.joined(separator: "\n"), image: UIImage(named: stat.name), accessoryImage: nil)
    }
}

extension MagicType: ListDisplayingGeneratable {
    static func displayable(_ magicType: MagicType) -> ListDisplayable {
        return ListDisplayable(title: magicType.name, information: magicType.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: magicType.benefits.joined(separator: "\n"), image: UIImage(named: magicType.name), accessoryImage: nil)
    }
}

extension Spell: ListDisplayingGeneratable {
    static func displayable(_ spell: Spell) -> ListDisplayable {
        var damage = spell.damage
        if damage.isNotEmpty {
            damage = "Damage: " + spell.damage
        }
        
        return ListDisplayable(title: spell.name, information: damage, additionalInfoTitle: nil, additionalInfo: spell.effects, subtext: spell.flavor, image: UIImage(named: spell.name), accessoryImage: nil)
    }
}

extension God: ListDisplayingGeneratable {
    static func displayable(_ god: God) -> ListDisplayable {
        return ListDisplayable(title: god.name, information: god.background, additionalInfoTitle: "Responsibilities", additionalInfo: god.responsibilties.joined(separator: "\n"), subtext: nil, image: UIImage(named: god.name), accessoryImage: nil)
    }
}

extension Monster: ListDisplayingGeneratable {
    static func displayable(_ monster: Monster) -> ListDisplayable {        
        return ListDisplayable(title: monster.name + " " + "(\(monster.health))", information: nil, additionalInfoTitle: nil, additionalInfo: nil, subtext: monster.explanation, image: UIImage(named: monster.name), accessoryImage: nil)
    }
}

extension Town: ListDisplayingGeneratable {
    static func displayable(_ town: Town) -> ListDisplayable {
        return ListDisplayable(title: town.name, information: town.background, additionalInfoTitle: "Merchants", additionalInfo: town.merchants.joined(separator: "\n"), subtext: nil, image: nil, accessoryImage: nil)
    }
}

extension MonsterAttack: ListDisplayingGeneratable {
    static func displayable(_ attack: MonsterAttack) -> ListDisplayable {
        return ListDisplayable(title: attack.name, information: attack.damage, additionalInfoTitle: nil, additionalInfo: nil, subtext: nil, image: nil, accessoryImage: nil)
    }
}

extension Quest: ListDisplayingGeneratable {
    static func displayable(_ quest: Quest) -> ListDisplayable {
        return ListDisplayable(title: quest.name, information: quest.explanation, additionalInfoTitle: "DM Notes", additionalInfo: quest.notes, subtext: quest.rewards.joined(separator: "\n"), image: nil, accessoryImage: nil)
    }
}

extension Merchant: ListDisplayingGeneratable {
    static func displayable(_ merchant: Merchant) -> ListDisplayable {
        return ListDisplayable(title: merchant.name, information: merchant.explanation, additionalInfoTitle: "Sells", additionalInfo: merchant.items.joined(separator: "\n"), subtext: "Located in " + merchant.location, image: nil, accessoryImage: nil)
    }
}

extension Note: ListDisplayingGeneratable {
    static func displayable(_ note: Note) -> ListDisplayable {
        return ListDisplayable(title: note.name, information: note.explanation, additionalInfoTitle: nil, additionalInfo: nil, subtext: nil, image: nil, accessoryImage: nil)
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
    
    static func displayableObjects<T: ListDisplayingGeneratable>(_ objects: [T]) -> [ListDisplayable] {
        return objects.map { return T.displayable($0) }
    }
    
    static func displayableObject<T: ListDisplayingGeneratable>(_ object: T) -> ListDisplayable {
        return T.displayable(object)
    }
}

extension ListDisplayable {
    
    var attributedString: NSAttributedString {
        get {
            let attributedString = NSMutableAttributedString()
            
            if let title = title, !title.isEmpty {
                let title = NSAttributedString.attributedStringWithHeadingAttributes(title)
                
                attributedString.append(title)
                attributedString.append(NSAttributedString(string: "\n"))
            }
            
            if let information = information, !information.isEmpty {
                let info = NSAttributedString.attributedStringWithBodyAttributes(information)
                
                attributedString.append(info)
                attributedString.append(NSAttributedString(string: "\n"))
            }
            
            if let additionalInfo = additionalInfo, !additionalInfo.isEmpty {

                if let title = additionalInfoTitle, !title.isEmpty {
                    attributedString.append(NSAttributedString(string: "\n"))

                    let attributedTitle = NSAttributedString.attributedStringWithSubHeadingAttributes(title)
                    attributedString.append(attributedTitle)
                    attributedString.append(NSAttributedString(string: "\n"))
                } else if information?.isEmpty == false {
                    attributedString.append(NSAttributedString(string: "\n"))
                }
                
                let additionalInfo = NSAttributedString.attributedStringWithBodyAttributes(additionalInfo)
                
                attributedString.append(additionalInfo)
                
                if let subtext = subtext, !subtext.isEmpty {
                    attributedString.append(NSAttributedString(string: "\n"))
                }
            }
            
            if let subtext = subtext, !subtext.isEmpty {
                let subtext = NSAttributedString.attributedStringWithSmallAttributes(subtext)
                attributedString.append(subtext)
            }
            
            return attributedString
        }
    }
}
