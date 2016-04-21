//
//  FontExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func headingFont() -> UIFont {
        return fontOfName("Avenir-Black", size: 18)
    }
    
    static func subHeadingFont() -> UIFont {
        return fontOfName("Avenir-Black", size: 16)
    }
    
    static func bodyFont() -> UIFont {
        return fontOfName("Avenir-Medium", size: 16)
    }
    
    static func smallFont() -> UIFont {
        return fontOfName("Avenir-Medium", size: 14)
    }
    
    static func verySmallFont() -> UIFont {
        return fontOfName("Avenir-Medium", size: 13)
    }
    
    static func heavyLargeFont() -> UIFont {
        return fontOfName("Avenir-Heavy", size: 21)
    }
    
    private static func fontOfName(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            assertionFailure()
            
            return UIFont.boldSystemFontOfSize(size)
        }
        
        return font
    }
}
