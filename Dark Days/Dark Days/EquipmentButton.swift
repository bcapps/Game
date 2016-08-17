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
    var equipmentSlot = EquipmentSlot.None
    
    var item: Item? {
        didSet {
            if let name = item?.name {
                setImage(UIImage(named: name), forState: .Normal)
            } else {
                setImage(slot.imageForItemSlot, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        layer.borderColor = UIColor.borderColor().CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 8.0
        
        imageView?.tintColor = UIColor(white: 0.5, alpha: 0.4)
        imageView?.contentMode = .ScaleAspectFit
        backgroundColor = UIColor(white: 0.7, alpha: 0.15)
    }
}

extension EquipmentButton {
    enum EquipmentSlot: Int {
        case None
        case Helmet
        case Chest
        case Boots
        case Accessory
        case LeftHand
        case RightHand
    }
}
