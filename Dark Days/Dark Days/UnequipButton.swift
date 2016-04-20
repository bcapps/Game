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
        setTitle("Unequip", forState: .Normal)
        titleLabel?.font = UIFont.bodyFont()
        setTitleColor(UIColor.redColor(), forState: .Normal)
        setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.7), forState: .Highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = Item(name: "", damage: "", effects: "", flavor: "", itemSlot: .None, twoHanded: false, statEffects: [], damageReductions: [], damageAvoidances: [], attackModifiers: [], damageModifiers: [], skills: [])
        
        super.init(coder: aDecoder)
    }
}
