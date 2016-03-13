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
    
    private func setupStatCell() {
        
    }
}
