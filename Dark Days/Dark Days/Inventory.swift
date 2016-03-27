//
//  Inventory.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class Inventory {
    var gold: Int = 0
    var items = [Item]()
    
    var equippedItems: [Item] {
        get {
            return items.filter({$0.equipped == true})
        }
    }
    
    init(gold: Int, items: [Item]) {
        self.gold = gold
        self.items = items
    }
}

final class InventoryCoder: NSObject, Coder {
    typealias CodeableType = Inventory
    
    private enum Keys: String {
        case Gold
        case Items
    }
    
    var value: Inventory?
    
    init(value: Inventory) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let gold = aDecoder.decodeIntegerForKey(Keys.Gold.rawValue)
        let rawItemCoders = aDecoder.decodeObjectForKey(Keys.Items.rawValue) as? [ItemCoder]
        let rawItems = rawItemCoders?.objects
        
        guard let items = rawItems else { return nil }
        
        value = Inventory(gold: gold, items: items)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.items.coders, forKey: Keys.Items.rawValue)
        aCoder.encodeInteger(value?.gold ?? 0, forKey: Keys.Gold.rawValue)
    }
}
