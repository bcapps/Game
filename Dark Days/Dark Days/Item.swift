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
    let statEffects: [StatEffect]
    let damageReductions: [DamageReduction]
    let damageAvoidances: [DamageAvoidance]
    let attackModifiers: [AttackModifier]
    
    var equippedSlot = EquipmentButton.EquipmentSlot.None
    
    static func decode(json: AnyObject) throws -> Item {        
        return try Item(name: json => "name",
            damage: json => "damage",
            effects: json => "effects",
            flavor: json => "flavor",
            itemSlot: ItemSlot(rawValue: json => "itemSlot") ?? .None,
            twoHanded: json =>? "twoHanded" ?? false,
            statEffects: json =>? "statEffects" ?? [],
            damageReductions: json =>? "damageReductions" ?? [],
            damageAvoidances: json =>? "damageAvoidances" ?? [],
            attackModifiers: json =>? "attackModifier" ?? [])
    }
    
    init(name: String, damage: String, effects: String, flavor: String, itemSlot: ItemSlot, twoHanded: Bool, statEffects: [StatEffect], damageReductions: [DamageReduction], damageAvoidances: [DamageAvoidance], attackModifiers: [AttackModifier]) {
        self.name = name
        self.damage = damage
        self.effects = effects
        self.flavor = flavor
        self.itemSlot = itemSlot
        self.twoHanded = twoHanded
        self.statEffects = statEffects
        self.damageReductions = damageReductions
        self.damageAvoidances = damageAvoidances
        self.attackModifiers = attackModifiers
    }
}

func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.name == rhs.name
}

extension Item: Unarchiveable {
    static var JSONName: String {
        return "Items"
    }
}


final class ItemCoder: GenericCoder<Item> {
    private enum Keys: String {
        case EquippedSlot
    }
    
    required init(value: Item) {
        super.init(value: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let equipped = aDecoder.decodeIntegerForKey(Keys.EquippedSlot.rawValue)
        
        value?.equippedSlot = EquipmentButton.EquipmentSlot(rawValue: equipped) ?? .None
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        
        aCoder.encodeInteger(value?.equippedSlot.rawValue ?? EquipmentButton.EquipmentSlot.None.rawValue, forKey: Keys.EquippedSlot.rawValue)
    }
}
