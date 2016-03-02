//
//  EquipmentButton.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class EquipmentButton: UIButton {
    var slot = ItemSlot.None
    var item: Item? {
        didSet {
            if let name = item?.name {
                imageView?.image = UIImage(named: name)
            }
            else {
                imageView?.image = slot.imageForItemSlot
            }
        }
    }
    
    override func awakeFromNib() {
        layer.borderColor = UIColor.borderColor().CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 8.0
        
        imageView?.tintColor = UIColor(white: 0.5, alpha: 0.7)
        backgroundColor = UIColor(white: 0.7, alpha: 0.15)
    }
}
