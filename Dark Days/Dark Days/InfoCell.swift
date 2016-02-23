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
    @IBOutlet weak var infoTextView: UITextView!
    
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
        infoTextView.font = UIFont.bodyFont()
        
        infoNameLabel.textColor = .headerTextColor()
        infoTextView.textColor = .bodyTextColor()
        
        backgroundColor = .backgroundColor()
        
        infoImageView.backgroundColor = backgroundColor
        infoNameLabel.backgroundColor = backgroundColor
        infoTextView.backgroundColor = backgroundColor
        infoTextView.textContainer.lineFragmentPadding = 0;
        infoTextView.textContainerInset = UIEdgeInsetsZero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var exclusionRect = infoTextView.convertRect(infoImageView.bounds, fromView: infoImageView)
        exclusionRect.size.width += (infoNameLabel.frame.origin.x - infoImageView.bounds.size.width) / 2.0
        exclusionRect.size.height += 5.0
        
        let imageViewPath = UIBezierPath(rect: exclusionRect)
        infoTextView.textContainer.exclusionPaths = [imageViewPath]
    }
}
