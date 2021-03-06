//
//  UnequipButton.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/13/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class UnequipButton: UIButton {
    var item: Item?
    
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
        fatalError("init(coder:) has not been implemented")
    }
}
