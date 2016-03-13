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
            infoImageButton.setImage(newValue, forState: .Normal)
        }
        get {
            return infoImageButton.imageForState(.Normal)
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
    
    var contentInset: UIEdgeInsets?
    
    @IBOutlet private weak var infoNameLabel: UILabel!
    @IBOutlet private weak var infoTextView: UITextView!
    @IBOutlet private weak var infoImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInfoCell()
    }
    
    private func setupInfoCell() {
        infoImageButton.layer.cornerRadius = infoImageButton.bounds.height / 2.0
        infoImageButton.layer.borderColor = UIColor.borderColor().CGColor
        infoImageButton.layer.borderWidth = 1.0
        infoImageButton.layer.masksToBounds = true
        
        infoNameLabel.font = UIFont.headingFont()
        infoTextView.font = UIFont.bodyFont()
        
        infoNameLabel.textColor = .headerTextColor()
        infoTextView.textColor = .bodyTextColor()
        
        backgroundColor = .clearColor()
        
        infoImageButton.backgroundColor = backgroundColor
        infoNameLabel.backgroundColor = backgroundColor
        infoTextView.backgroundColor = backgroundColor
        infoTextView.textContainer.lineFragmentPadding = 0
        infoTextView.textContainerInset = UIEdgeInsetsZero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 1.0)
        selectedBackgroundView = backgroundView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoImageButton.contentEdgeInsets = contentInset ?? UIEdgeInsets()

        var exclusionRect = infoTextView.convertRect(infoImageButton.frame, fromView: self)
        let infoLabelFrame = infoTextView.convertRect(infoNameLabel.frame, fromView: self)
        
        exclusionRect.size.width += (infoLabelFrame.origin.x - infoImageButton.bounds.size.width)
        exclusionRect.size.height += 5.0
        
        let imageViewPath = UIBezierPath(rect: exclusionRect)
        infoTextView.textContainer.exclusionPaths = [imageViewPath]        
    }
}
