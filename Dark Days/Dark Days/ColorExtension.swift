//
//  ColorExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func backgroundColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    static func headerTextColor() -> UIColor {
        return UIColor(white: 0.9, alpha: 1.0)
    }
    
    static func bodyTextColor() -> UIColor {
        return UIColor(white: 0.7, alpha: 1.0)
    }
    
    static func borderColor() -> UIColor {
        return UIColor(white: 0.5, alpha: 1.0)
    }
}
