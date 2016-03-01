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
        case "hand":
            return .Hand
        default:
            return .None
        }
    }
}

struct Item: Decodable, Nameable, Codeable {
    typealias CoderType = ItemCoder
    
    let name: String
    let damage: String
    let effects: String
    let flavor: String
    let itemSlot: ItemSlot
    let twoHanded: Bool
    
    static func decode(json: AnyObject) throws -> Item {
        return try Item(name: json => "name",
            damage: json => "damage",
            effects: json => "effects",
            flavor: json => "flavor",
            itemSlot: ItemSlot.itemSlotForItemString(json => "itemSlot"),
            twoHanded: json => "twohanded")
    }
}

final class ItemCoder: NSObject, Coder {
    typealias CodeableType = Item
    
    private enum Keys: String {
        case Name
    }
    
    var value: Item?
    
    init(value: Item) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        
        guard let name = rawName else {
            value = nil
            super.init()
            
            return nil
        }
        
        value = ObjectProvider.itemForName(name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}
