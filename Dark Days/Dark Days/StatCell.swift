//
//  StatCell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/12/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class StatCell: UICollectionViewCell {
    
    @IBOutlet weak var statTitle: UILabel!
    @IBOutlet weak var statValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStatCell()
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
    
    private func setupStatCell() {
        
    }
}
