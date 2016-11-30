//
//  UnequipButton.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/13/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class UnequipButton: UIButton {
    let item: Item
    
    init(item: Item) {
        self.item = item

        super.init(frame: CGRect())

        backgroundColor = .backgroundColor()
        setTitle("Unequip", for: UIControlState())
        titleLabel?.font = UIFont.bodyFont()
        setTitleColor(UIColor.red, for: UIControlState())
        setTitleColor(UIColor.red.withAlphaComponent(0.7), for: .highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = Item(name: "", damage: "", effects: "", flavor: "", itemSlot: .None, twoHanded: false, ranged: false, statModifiers: [], damageReductions: [], damageAvoidances: [], attackModifiers: [], damageModifiers: [], skills: [], inventorySkills: [], spells: [])
        
        super.init(coder: aDecoder)
    }
}
