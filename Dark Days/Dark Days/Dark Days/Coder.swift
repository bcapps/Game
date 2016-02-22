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

extension CollectionType where Generator.Element: Codeable, Generator.Element.CoderType.ObjectType == Generator.Element, Generator.Element.CoderType: Coder {
    var coders: [Generator.Element.CoderType] {
        return map { element in
            return Generator.Element.CoderType(value: element)
        }
    }
}

extension CollectionType where Generator.Element: Coder, Generator.Element.ObjectType: Codeable, Generator.Element.ObjectType.CoderType == Generator.Element {
    var objects: [Generator.Element.ObjectType] {
        let objectsAndNils = map { element in
            return element.value
        }
        
        return objectsAndNils.flatMap { $0 }
    }
}
