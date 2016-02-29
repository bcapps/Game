//
//  InfoCell.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class InfoCell: UITableViewCell {
    var infoImage: UIImage? {
        set {
            infoImageView.image = newValue
        }
        get {
            return infoImageView.image
        }
    }
    
    var nameText: String? {
        set {
            infoNameLabel.text = newValue
        }
        get {
            return infoNameLabel.text
        }
    }
    
    var infoAttributedText: NSAttributedString? {
        set {
            infoTextView.attributedText = newValue
            layoutIfNeeded()
        }
        get {
            return infoTextView.attributedText
        }
    }
    
    @IBOutlet private weak var infoImageView: UIImageView!
    @IBOutlet private weak var infoNameLabel: UILabel!
    @IBOutlet private weak var infoTextView: UITextView!
    
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 1.0)
        selectedBackgroundView = backgroundView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var exclusionRect = infoTextView.convertRect(infoImageView.frame, fromView: self)
        let infoLabelFrame = infoTextView.convertRect(infoNameLabel.frame, fromView: self)
        
        exclusionRect.size.width += (infoLabelFrame.origin.x - infoImageView.bounds.size.width)
        exclusionRect.size.height += 5.0
        
        let imageViewPath = UIBezierPath(rect: exclusionRect)
        infoTextView.textContainer.exclusionPaths = [imageViewPath]        
    }
}
