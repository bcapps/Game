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
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = Item(name: "", damage: "", effects: "", flavor: "", itemSlot: .None, twoHanded: false)
        
        super.init(coder: aDecoder)
    }
}
