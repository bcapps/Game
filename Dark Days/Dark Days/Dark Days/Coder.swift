//
//  Coder.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

protocol Codeable {
    typealias CoderType: Coder
}

protocol Coder: NSCoding {
    typealias ObjectType = Codeable
    
    var value: ObjectType? { get set }
    
    init(value: ObjectType)
}

extension Array where Element: Codeable, Element.CoderType.ObjectType == Element, Element.CoderType: Coder {
    var coders: [Element.CoderType] {
        return map { element in
            return Element.CoderType(value: element)
        }
    }
}

extension Array where Element: Coder, Element.ObjectType: Codeable, Element.ObjectType.CoderType == Element {
    var objects: [Element.ObjectType] {
        let objectsAndNils = map { element in
            return element.value
        }
        
        return objectsAndNils.flatMap { $0 }
    }
}
