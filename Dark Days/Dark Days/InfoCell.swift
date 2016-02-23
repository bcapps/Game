//
//  InfoCell.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class InfoCell: UITableViewCell {
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoNameLabel: UILabel!
    @IBOutlet weak var infoDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInfoCell()
    }
    
    private func setupInfoCell() {
        infoImageView.layer.cornerRadius = infoImageView.bounds.height / 2.0
        infoImageView.layer.borderColor = UIColor.borderColor().CGColor
        infoImageView.layer.borderWidth = 1.0
        infoImageView.layer.masksToBounds = true
        
        infoNameLabel.font = UIFont.headingFont()
        infoDescriptionLabel.font = UIFont.bodyFont()
        
        infoNameLabel.textColor = .headerTextColor()
        infoDescriptionLabel.textColor = .bodyTextColor()
        
        backgroundColor = .backgroundColor()
        
        infoImageView.backgroundColor = backgroundColor
        infoNameLabel.backgroundColor = backgroundColor
        infoDescriptionLabel.backgroundColor = backgroundColor
    }
}
