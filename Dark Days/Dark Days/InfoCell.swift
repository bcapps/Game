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
        
        infoTextView.font = UIFont.bodyFont()
        infoTextView.textColor = .bodyTextColor()
        
        backgroundColor = .clearColor()
        
        infoImageButton.backgroundColor = backgroundColor
        infoTextView.backgroundColor = backgroundColor
        infoTextView.textContainer.lineFragmentPadding = 0
        infoTextView.textContainerInset = UIEdgeInsetsZero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 1.0)
        selectedBackgroundView = backgroundView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard infoImageButton.imageForState(.Normal) != nil else {
            infoImageButton.hidden = true
            return
        }
        
        infoImageButton.hidden = false
        infoImageButton.contentEdgeInsets = contentInset ?? UIEdgeInsets()
        
        var exclusionRect = infoTextView.convertRect(infoImageButton.frame, fromView: self)
        
        exclusionRect.size.width += 10.0
        exclusionRect.size.height += 5.0
        
        let imageViewPath = UIBezierPath(rect: exclusionRect)
        infoTextView.textContainer.exclusionPaths = [imageViewPath]        
    }
}
