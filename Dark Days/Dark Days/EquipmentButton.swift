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
    var equipmentSlot = EquipmentSlot.none
    
    var item: Item? {
        didSet {
            if let name = item?.name {
                setImage(UIImage(named: name), for: UIControlState())
            } else {
                setImage(slot.imageForItemSlot, for: UIControlState())
            }
        }
    }
    
    override func awakeFromNib() {
        layer.borderColor = UIColor.borderColor().cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8.0
        
        imageView?.tintColor = UIColor(white: 0.5, alpha: 0.4)
        imageView?.contentMode = .scaleAspectFit
        backgroundColor = UIColor(white: 0.7, alpha: 0.15)
    }
}

extension EquipmentButton {
    enum EquipmentSlot: Int {
        case none
        case helmet
        case chest
        case boots
        case accessory
        case leftHand
        case rightHand
    }
}
