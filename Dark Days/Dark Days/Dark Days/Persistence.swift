//
//  Persister.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

protocol Persistable {
    typealias PersisterType: Persister
}

protocol Persister: NSCoding {
    typealias ObjectType = Persistable
    
    var value: ObjectType? { get set }
    
    init(value: ObjectType)
}

extension CollectionType where Generator.Element: Persistable, Generator.Element.PersisterType.ObjectType == Generator.Element, Generator.Element.PersisterType: Persister {
    var persisters: [Generator.Element.PersisterType] {
        return map { element in
            return Generator.Element.PersisterType(value: element)
        }
    }
}

extension CollectionType where Generator.Element: Persister, Generator.Element.ObjectType: Persistable, Generator.Element.ObjectType.PersisterType == Generator.Element {
    var objects: [Generator.Element.ObjectType] {
        let objectsAndNils = map { element in
            return element.value
        }
        
        return objectsAndNils.flatMap { $0 }
    }
}
