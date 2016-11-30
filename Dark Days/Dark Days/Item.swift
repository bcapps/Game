//
//  Item.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

enum ItemSlot: String {
    case None = "None"
    case Helmet = "Helmet"
    case Chest = "Chest"
    case Boots = "Boots"
    case Accessory = "Accessory"
    case Hand = "Hand"
    
    var imageForItemSlot: UIImage? {
        get {
            return UIImage(named: self.rawValue)
        }
    }
    
    static let allValues = [Accessory, Boots, Chest, Hand, Helmet, None]
}

final class Item: Decodable, Nameable, Codeable, Equatable {
    typealias CoderType = ItemCoder
    
    let name: String
    let damage: String
    let effects: String
    let flavor: String
    let itemSlot: ItemSlot
    let twoHanded: Bool
    let ranged: Bool
    let statModifiers: [StatModifier]
    let damageReductions: [DamageReduction]
    let damageAvoidances: [DamageAvoidance]
    let attackModifiers: [AttackModifier]
    let damageModifiers: [DamageModifier]
    let skills: [Skill]
    let inventorySkills: [Skill]
    let spells: [Spell]
    
    var equippedSlot = EquipmentButton.EquipmentSlot.none
    
    var imageForItemType: UIImage? {
        get {
            if itemSlot == .Hand {
                if twoHanded {
                    return UIImage(named: "TwoHandedIcon.png")
                }
                
                return UIImage(named: "RightHand")
            }
            
            return UIImage(named: itemSlot.rawValue)
        }
    }
    
    static func decode(_ json: Any) throws -> Item {        
        return try Item(name: json => "name",
            damage: json => "damage",
            effects: json => "effects",
            flavor: json => "flavor",
            itemSlot: ItemSlot(rawValue: json => "itemSlot") ?? .None,
            twoHanded: json =>? "twoHanded" ?? false,
            ranged: json =>? "ranged" ?? false,
            statModifiers: json =>? "statModifiers" ?? [],
            damageReductions: json =>? "damageReductions" ?? [],
            damageAvoidances: json =>? "damageAvoidances" ?? [],
            attackModifiers: json =>? "attackModifiers" ?? [],
            damageModifiers: json =>? "damageModifiers" ?? [],
            skills: json =>? "skills" ?? [],
            inventorySkills: json =>? "inventorySkills" ?? [],
            spells: json =>? "spells" ?? [])
    }
    
    init(name: String, damage: String, effects: String, flavor: String, itemSlot: ItemSlot, twoHanded: Bool, ranged: Bool, statModifiers: [StatModifier], damageReductions: [DamageReduction], damageAvoidances: [DamageAvoidance], attackModifiers: [AttackModifier], damageModifiers: [DamageModifier], skills: [String], inventorySkills: [String], spells: [String]) {
        self.name = name
        self.damage = damage
        self.effects = effects
        self.flavor = flavor
        self.itemSlot = itemSlot
        self.twoHanded = twoHanded
        self.ranged = ranged
        self.statModifiers = statModifiers
        self.damageReductions = damageReductions
        self.damageAvoidances = damageAvoidances
        self.attackModifiers = attackModifiers
        self.damageModifiers = damageModifiers
        self.skills = skills.flatMap { return ObjectProvider.skillForName($0) }
        self.inventorySkills = inventorySkills.flatMap { return ObjectProvider.skillForName($0) }
        self.spells = spells.flatMap { return ObjectProvider.spellForName($0) }
    }
}

func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.name == rhs.name
}

final class ItemCoder: NSObject, Coder {
    fileprivate enum Keys: String {
        case Name
        case EquippedSlot
    }
    
    var value: Item?
    
    init(value: Item) {
        self.value = value
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        let equipped = aDecoder.decodeInteger(forKey: Keys.EquippedSlot.rawValue)
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.itemForName(name)
        
        value?.equippedSlot = EquipmentButton.EquipmentSlot(rawValue: equipped) ?? .none
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encode(value?.equippedSlot.rawValue ?? EquipmentButton.EquipmentSlot.none.rawValue, forKey: Keys.EquippedSlot.rawValue)
    }
}
