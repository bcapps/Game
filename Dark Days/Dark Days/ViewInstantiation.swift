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
    
    class func defaultNibName() -> String {
        return className()
    }
    
    class func instantiateViewFromNib<T: UIView>(nibName: String = T.defaultNibName()) -> T? {
        return UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil).first as? T
    }
    
    func viewFromNib(nibName: String?) -> UIView? {
        guard subviews.count == 0 else { return self }
        
        let name = nibName ?? self.dynamicType.defaultNibName()
        
        let nibView: UIView? = UIView.instantiateViewFromNib(name)
        guard let view = nibView else { return nil }
        
        view.frame = frame
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        view.autoresizingMask = autoresizingMask
        view.userInteractionEnabled = userInteractionEnabled
        
        constraints.forEach { constraint in
            let firstItem = constraint.firstItem as? UIView == self ? view : constraint.firstItem
            let secondItem = constraint.secondItem as? UIView == self ? view : constraint.secondItem
            
            let newConstraint = NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant)
            newConstraint.priority = constraint.priority
            
            view.addConstraint(newConstraint)
        }
        
        removeConstraints(constraints)
        
        return view
    }
    
    private static func className() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last ?? ""
    }
}
