//
//  HeroMenuCell.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroMenuCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupHeroMenuCell()
    }
    
    private func setupHeroMenuCell() {
        backgroundColor = .backgroundColor()
        
        textLabel?.font = UIFont.headingFont()
        textLabel?.textColor = .headerTextColor()
    }
}
