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
        return String(describing: Mirror(reflecting: self).subjectType)
    }
}

extension UITableViewCell : Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    
    enum ViewType {
        case cell
        case headerFooter
    }
    
    func registerClass<T: UIView>(_ aClass: T.Type, type: ViewType) where T: Reusable {
        switch type {
        case .cell:
            register(aClass, forCellReuseIdentifier: T.reuseIdentifier)
        case .headerFooter:
            register(aClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func registerNib<T: UIView>(_ aNib: UINib, aClass: T.Type, type: ViewType) where T: Reusable {
        switch type {
        case .cell:
            register(aNib, forCellReuseIdentifier: T.reuseIdentifier)
        case .headerFooter:
            register(aNib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UIView>(_ aClass: T.Type, type: ViewType) -> T? where T: Reusable {
        switch type {
        case .cell:
            return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
        case .headerFooter:
            return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
        }
    }
}
