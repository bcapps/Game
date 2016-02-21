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

struct Item: Decodable, Nameable {
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