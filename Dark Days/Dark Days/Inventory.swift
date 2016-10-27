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
            return items.filter({$0.equippedSlot != .none})
        }
    }
    
    var equippedItemSets: [ItemSet] {
        get {
            let x: [ItemSet] = ObjectProvider.objectsForJSON("ItemSets")
            print(x)
            return ObjectProvider.objectsForJSON("ItemSets").filter { isItemSetEquipped($0) }
        }
    }
    
    fileprivate func isItemSetEquipped(_ itemSet: ItemSet) -> Bool {
        let equippedItemNames = Set(equippedItems.map { $0.name })
        let itemSetNames = Set(itemSet.itemNamesInSet)
        
        return itemSetNames.isSubset(of: equippedItemNames)
    }
    
    init(gold: Int, items: [Item]) {
        self.gold = gold
        self.items = items
    }
}

final class InventoryCoder: NSObject, Coder {
    typealias CodeableType = Inventory
    
    fileprivate enum Keys: String {
        case Gold
        case Items
    }
    
    var value: Inventory?
    
    init(value: Inventory) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let gold = aDecoder.decodeInteger(forKey: Keys.Gold.rawValue)
        let rawItemCoders = aDecoder.decodeObject(forKey: Keys.Items.rawValue) as? [ItemCoder]
        let rawItems = rawItemCoders?.objects
        
        guard let items = rawItems else { return nil }
        
        value = Inventory(gold: gold, items: items)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.items.coders, forKey: Keys.Items.rawValue)
        aCoder.encode(value?.gold ?? 0, forKey: Keys.Gold.rawValue)
    }
}
