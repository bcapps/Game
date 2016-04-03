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

final class Item: Decodable, Nameable, Codeable {
    typealias CoderType = ItemCoder
    
    let name: String
    let damage: String
    let effects: String
    let flavor: String
    let itemSlot: ItemSlot
    let twoHanded: Bool
    let statEffects: [StatEffect]
    
    var equipped = false
    
    static func decode(json: AnyObject) throws -> Item {
        let twoHanded: Bool
        let statEffects: [StatEffect]
        
        do { twoHanded = try json => "twoHanded" } catch { twoHanded = false }
        do { statEffects = try json => "statEffects" } catch { statEffects = [] }
        
        return try Item(name: json => "name",
            damage: json => "damage",
            effects: json => "effects",
            flavor: json => "flavor",
            itemSlot: ItemSlot(rawValue: json => "itemSlot") ?? .None,
            twoHanded: twoHanded,
            statEffects: statEffects)
    }
    
    init(name: String, damage: String, effects: String, flavor: String, itemSlot: ItemSlot, twoHanded: Bool, statEffects: [StatEffect]) {
        self.name = name
        self.damage = damage
        self.effects = effects
        self.flavor = flavor
        self.itemSlot = itemSlot
        self.twoHanded = twoHanded
        self.statEffects = statEffects
    }
}

final class ItemCoder: NSObject, Coder {
    typealias CodeableType = Item
    
    private enum Keys: String {
        case Name
        case Equipped
    }
    
    var value: Item?
    
    init(value: Item) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        let equipped = aDecoder.decodeBoolForKey(Keys.Equipped.rawValue)
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.itemForName(name)
        value?.equipped = equipped
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
        aCoder.encodeBool(value?.equipped ?? false, forKey: Keys.Equipped.rawValue)
    }
}
