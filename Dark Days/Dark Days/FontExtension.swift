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
    
    static func heavyExtraLargeFont() -> UIFont {
        return fontOfName("Avenir-Heavy", size: 27)
    }
    
    static func petiteCapsFont(ofSize size: CGFloat) -> UIFont {
        return fontOfName("MrsEavesPetiteCapsPetiteCaps", size: size)
    }
    
    static func notoSansRegular(ofSize size: CGFloat) -> UIFont {
        return fontOfName("NotoSans", size: size)
    }
    
    static func notoSansItalic(ofSize size: CGFloat) -> UIFont {
        return fontOfName("NotoSans-Italic", size: size)
    }
    
    static func notoSansBold(ofSize size: CGFloat) -> UIFont {
        return fontOfName("NotoSans-Bold", size: size)
    }
    
    static func notoSansBoldItalic(ofSize size: CGFloat) -> UIFont {
        return fontOfName("NotoSans-BoldItalic", size: size)
    }
    
    fileprivate static func fontOfName(_ name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            assertionFailure()
            
            return UIFont.boldSystemFont(ofSize: size)
        }
        
        return font
    }
}
