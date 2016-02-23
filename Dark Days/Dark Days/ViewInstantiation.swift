//
//  ViewInstantiation.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIView {
    static var nib: UINib {
        let className = NSStringFromClass(self).componentsSeparatedByString(".").last ?? ""

        return UINib(nibName: className, bundle: NSBundle.mainBundle())
    }
}
