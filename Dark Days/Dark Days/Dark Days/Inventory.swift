//
//  Inventory.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

struct Inventory {
    var gold: Int = 0
    var items = [Item]()
}

final class InventoryCoder: NSObject, Coder {
    typealias ObjectType = Inventory
    
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
//        let gold = aDecoder.decodeIntegerForKey(Keys.Gold.rawValue)
//        let rawItemCoders = aDecoder.decodeObjectForKey(Keys.Items.rawValue) as? [ItemCoder]
//        
//        guard let items = rawItems else {
//            value = nil
//            super.init()
//            
//            return nil
//        }
//        
//        value = Inventory(gold: gold, items: items)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let value = value {
            let coders = value.items.coders
            //let itemCoders: [ItemCoder] = codersFromItems(value.items)
        }
        
        //aCoder.encodeInteger(inventory?.gold ?? 0, forKey: Keys.Gold.rawValue)
        
//        aCoder.encodeObject(inventory?.background, forKey: Keys.Background.rawValue)
//        aCoder.encodeObject(inventory?.towns, forKey: Keys.Towns.rawValue)
    }
}