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
            infoImageView.isHidden = newValue == nil

            setNeedsLayout()
            layoutIfNeeded()
        }
        get {
            return infoImageView.image
        }
    }
    
    var accessoryImage: UIImage? {
        set {
            accessoryImageView.image = newValue
            accessoryImageView.isHidden = newValue == nil

            setNeedsLayout()
            layoutIfNeeded()
        }
        get {
            return accessoryImageView.image
        }
    }
    
    var infoAttributedText: NSAttributedString? {
        set {
            infoTextView.attributedText = newValue
            
            setNeedsLayout()
            layoutIfNeeded()
        }
        get {
            return infoTextView.attributedText
        }
    }
    
    var contentInset: UIEdgeInsets?
    
    @IBOutlet fileprivate weak var accessoryImageView: UIImageView!
    @IBOutlet fileprivate weak var infoTextView: UITextView!
    @IBOutlet fileprivate weak var infoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInfoCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoTextView.textContainer.exclusionPaths = []
        
        if !infoImageView.isHidden {
            addImageExclusionRect()
        }
        
        if !accessoryImageView.isHidden {
            addAccessoryImageExclusionRect()
        }
        
        infoImageView.layer.cornerRadius = infoImageView.bounds.height / 2.0
    }
    
    private func setupInfoCell() {
        infoImageView.layer.borderColor = UIColor.borderColor().cgColor
        infoImageView.layer.borderWidth = 1.0
        infoImageView.layer.masksToBounds = true
        infoImageView.contentMode = .scaleAspectFit
        infoTextView.font = .bodyFont()
        infoTextView.textColor = .bodyTextColor()
        
        backgroundColor = .backgroundColor()
        
        infoImageView.backgroundColor = backgroundColor
        infoTextView.backgroundColor = backgroundColor
        infoTextView.textContainer.lineFragmentPadding = 0
        infoTextView.textContainerInset = UIEdgeInsets.zero
        
        accessoryImageView.backgroundColor = backgroundColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.13, alpha: 1.0)
        selectedBackgroundView = backgroundView
    }
    
    private func addImageExclusionRect() {
        let exclusionRect = CGRect(x: 0, y: 0, width: infoImageView.frame.maxX + 5, height: infoImageView.frame.maxY + 5)
        
        let imageViewPath = UIBezierPath(rect: exclusionRect)
        
        infoTextView.textContainer.exclusionPaths += [imageViewPath]
    }
    
    private func addAccessoryImageExclusionRect() {
        var exclusionRect = convert(accessoryImageView.frame, to: infoTextView)
        exclusionRect.size.width = frame.size.width - exclusionRect.origin.x
        exclusionRect.size.height += 5.0
        
        let accessoryImagePath = UIBezierPath(rect: exclusionRect)
        
        infoTextView.textContainer.exclusionPaths += [accessoryImagePath]
    }
}
