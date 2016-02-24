//
//  AttributedStringExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    static func attributedStringWithAttributes(string: String, color: UIColor?, font: UIFont?, paragraphStyle: NSParagraphStyle?) -> NSAttributedString {
        
        var attributes = [String: AnyObject]()
        attributes[NSForegroundColorAttributeName] = color
        attributes[NSFontAttributeName] = font
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    static func attributedStringWithBodyAttributes(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.85

        return attributedStringWithAttributes(string, color: .bodyTextColor(), font: .bodyFont(), paragraphStyle: paragraphStyle)
    }
    
    static func attributedStringWithHeadingAttributes(string: String) -> NSAttributedString {
        return attributedStringWithAttributes(string, color: .headerTextColor(), font: .headingFont(), paragraphStyle: nil)
    }
    
    static func attributedStringWithSmallAttributes(string: String) -> NSAttributedString {
        return attributedStringWithAttributes(string, color: .sideTextColor(), font: .smallFont(), paragraphStyle: nil)
    }
}
