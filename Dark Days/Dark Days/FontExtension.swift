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
        return UIFont(name: "Avenir-Black", size: 18.0) ?? UIFont.boldSystemFontOfSize(18.0)
    }
    
    static func bodyFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 16.0) ?? UIFont.systemFontOfSize(17.0)
    }
    
    static func smallFont() -> UIFont {
        return UIFont(name: "Avenir-Medium", size: 14.0) ?? UIFont.systemFontOfSize(14.0)
    }
}
