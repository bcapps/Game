//
//  StatusEffectCell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/14/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import BEMCheckBox

final class StatusEffectCell: UICollectionViewCell {
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkBox.onTintColor = .white
        checkBox.onCheckColor = .white
        
        checkBox.onAnimationType = .bounce
        checkBox.offAnimationType = .bounce
    }
}
