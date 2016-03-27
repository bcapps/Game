//
//  ItemArrayExtension.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/26/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

extension Array where Element: Item {
    var sectionedItems: [SectionList<Item>] {
        var sections = [SectionList<Item>]()
        
        for slot in ItemSlot.allValues {
            guard let items: [Item] = self.filter({ $0.itemSlot == slot }) where items.isNotEmpty else { continue }
            
            sections.append(SectionList(sectionTitle: slot.rawValue, objects: items))
        }
        
        return sections
    }
}
