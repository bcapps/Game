//
//  Displayable.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol Displayable {
    var title: NSAttributedString? { get }
    var shortDescription: NSAttributedString? { get }
    var extendedDescription: NSAttributedString? { get }
    var image: UIImage? { get }
}

extension Hero: Displayable {
    var title: NSAttributedString? {
        return NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.headingFont(), NSForegroundColorAttributeName: UIColor.headerTextColor()])
    }
    
    var shortDescription: NSAttributedString? {
        return nil
    }
    
    var extendedDescription: NSAttributedString? {
        return nil
    }
    
    var image: UIImage? {
        return race.image
    }
}