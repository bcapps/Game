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
            infoImageButton.setImage(newValue, for: UIControlState())
            infoImageButton.isHidden = newValue == nil
            
            setNeedsLayout()
        }
        get {
            return infoImageButton.image(for: UIControlState())
        }
    }
    
    var accessoryImage: UIImage? {
        set {
            accessoryImageView.image = newValue
            accessoryImageView.isHidden = newValue == nil

            setNeedsLayout()
        }
        get {
            return accessoryImageView.image
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
    
    @IBOutlet fileprivate weak var accessoryImageView: UIImageView!
    @IBOutlet fileprivate weak var infoTextView: UITextView!
    @IBOutlet fileprivate weak var infoImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInfoCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoTextView.textContainer.exclusionPaths = []
        
        if infoImage != nil {
            addImageExclusionRect()
        }
        
        if accessoryImage != nil {
            addAccessoryImageExclusionRect()
        }
    }
    
    fileprivate func setupInfoCell() {
        infoImageButton.layer.cornerRadius = infoImageButton.bounds.height / 2.0
        infoImageButton.layer.borderColor = UIColor.borderColor().cgColor
        infoImageButton.layer.borderWidth = 1.0
        infoImageButton.layer.masksToBounds = true
        infoImageButton.imageView?.contentMode = .scaleAspectFit
        infoTextView.font = UIFont.bodyFont()
        infoTextView.textColor = .bodyTextColor()
        
        backgroundColor = .backgroundColor()
        
        infoImageButton.backgroundColor = backgroundColor
        infoTextView.backgroundColor = backgroundColor
        infoTextView.textContainer.lineFragmentPadding = 0
        infoTextView.textContainerInset = UIEdgeInsets.zero
        
        accessoryImageView.backgroundColor = backgroundColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 1.0)
        selectedBackgroundView = backgroundView
    }
    
    fileprivate func addImageExclusionRect() {
        var exclusionRect = infoTextView.convert(infoImageButton.frame, from: self)
        exclusionRect.size.width += 10.0
        exclusionRect.size.height += 5.0
        
        let imageViewPath = UIBezierPath(rect: exclusionRect)
        
        infoTextView.textContainer.exclusionPaths += [imageViewPath]
    }
    
    fileprivate func addAccessoryImageExclusionRect() {
        var exclusionRect = infoTextView.convert(accessoryImageView.frame, from: self)
        exclusionRect.size.width += 20.0
        exclusionRect.size.height += 5.0
        
        let accessoryImagePath = UIBezierPath(rect: exclusionRect)
        
        infoTextView.textContainer.exclusionPaths += [accessoryImagePath]
    }
}
