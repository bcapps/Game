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
        let className = NSStringFromClass(self).components(separatedBy: ".").last ?? ""
        
        return UINib(nibName: className, bundle: Bundle.main)
    }
    
    
    static func defaultNibName() -> String {
        return className()
    }
    
    /**
     Loads a view of the generic class type from a nib.
     
     - parameter nibName: The name of the nib. By default, the name of the generic class T.
     
     - returns: A view of the generic class type from a nib.
     */
    static func instantiateViewFromNib<T: UIView>(_ nibName: String) -> T? {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
    }
    
    /**
     Loads a view of `self` where the name of the nib is the name of class `self`.
     
     - returns: A view of class `self` provided that there is a nib with the class name.
     */
    static func instantiateViewFromNib() -> Self? {
        return instantiateViewFromNib(defaultNibName())
    }
    
    /**
     Call this method in `awakeFromCoder:` to load a view from the nib file with the intention of replacing `self` with that view. Technique taken from [Cocoanuts](http://cocoanuts.mobi/2014/03/26/reusable).
     
     - parameter nibName: The name of the nib to load the view from, or nil to use the class name.
     
     - returns: A view loaded from a nib, with all of its constraints recreated. Return this return value from `awakeFromCoder:`.
     */
    func viewFromNib(_ nibName: String?) -> UIView? {
        // In this case, the method has already been called and will recurse. Return `self` so this does not happen.
        guard subviews.isEmpty else { return self }
        
        let name = nibName ?? type(of: self).defaultNibName()
        
        let nibView: UIView? = UIView.instantiateViewFromNib(name)
        guard let view = nibView else { return nil }
        
        view.frame = frame
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        view.autoresizingMask = autoresizingMask
        view.isUserInteractionEnabled = isUserInteractionEnabled
        
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
    
    fileprivate static func className() -> String {
        return String(describing: self)
    }
}
