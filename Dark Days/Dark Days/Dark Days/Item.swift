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
    case OneHand = "One Handed"
    case TwoHand = "Two Handed"
    
    static func itemSlotForItemString(itemString: String) -> ItemSlot {
        switch itemString {
        case "helmet":
            return .Helmet
        case "chest":
            return .Chest
        case "boots":
            return .Boots
        case "accessory":
            return .Accessory
        case "onehand":
            return .OneHand
        case "twohand":
            return .TwoHand
        default:
            return .None
        }
    }
}

struct Item: Decodable, Nameable, Persistable {
    typealias PersisterType = ItemCoder
    
    let name: String
    let damage: String
    let effects: String
    let flavor: String
    let itemSlot: ItemSlot
    
    static func decode(json: AnyObject) throws -> Item {
        return try Item(name: json => "name",
            damage: json => "damage",
            effects: json => "effects",
            flavor: json => "flavor",
            itemSlot: ItemSlot.itemSlotForItemString(json => "itemSlot"))
    }
}

final class ItemCoder: NSObject, Persister {
    typealias ObjectType = Item
    
    private enum Keys: String {
        case Name
        case Damage
        case Effects
        case Flavor
        case ItemSlot
    }
    
    var value: Item?
    
    init(value: Item) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        let rawDamage = aDecoder.decodeObjectForKey(Keys.Damage.rawValue) as? String
        let rawEffects = aDecoder.decodeObjectForKey(Keys.Effects.rawValue) as? String
        let rawFlavor = aDecoder.decodeObjectForKey(Keys.Flavor.rawValue) as? String
        let rawItemSlot = aDecoder.decodeObjectForKey(Keys.ItemSlot.rawValue) as? String ?? ""
        
        guard let name = rawName, damage = rawDamage, effects = rawEffects, flavor = rawFlavor, itemSlot = ItemSlot(rawValue: rawItemSlot) else {
            value = nil
            super.init()
            
            return nil
        }
        
        value = Item(name: name, damage: damage, effects: effects, flavor: flavor, itemSlot: itemSlot)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encodeObject(value?.damage, forKey: Keys.Damage.rawValue)
        aCoder.encodeObject(value?.effects, forKey: Keys.Effects.rawValue)
        aCoder.encodeObject(value?.flavor, forKey: Keys.Flavor.rawValue)
        aCoder.encodeObject(value?.itemSlot.rawValue, forKey: Keys.ItemSlot.rawValue)        
    }    
}
