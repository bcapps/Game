//
//  Reusable.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        let mirror = Mirror(reflecting: self)
        return String(mirror.subjectType)
    }
}

extension UITableViewCell : Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    
    enum Type {
        case Cell
        case HeaderFooter
    }
    
    func registerClass<T: UIView where T: Reusable>(aClass: T.Type, type: Type) {
        switch (type) {
        case .Cell:
            registerClass(aClass, forCellReuseIdentifier: T.reuseIdentifier)
        case .HeaderFooter:
            registerClass(aClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func registerNib<T: UIView where T: Reusable>(aNib: UINib, aClass: T.Type, type: Type) {
        switch (type) {
        case .Cell:
            registerNib(aNib, forCellReuseIdentifier: T.reuseIdentifier)
        case .HeaderFooter:
            registerNib(aNib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UIView where T: Reusable>(aClass: T.Type, type: Type) -> T {
        switch (type) {
        case .Cell:
            return dequeueReusableCellWithIdentifier(T.reuseIdentifier) as! T
        case .HeaderFooter:
            return dequeueReusableHeaderFooterViewWithIdentifier(T.reuseIdentifier) as! T
            
        }
    }
}
