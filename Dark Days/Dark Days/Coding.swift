//
//  Coder.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

protocol Codeable {
    associatedtype CoderType: Coder
}

protocol Coder: NSCoding {
    associatedtype CodeableType = Codeable
    
    var value: CodeableType? { get set }
    
    init(value: CodeableType)
}

extension CollectionType where Generator.Element: Codeable, Generator.Element.CoderType.CodeableType == Generator.Element, Generator.Element.CoderType: Coder {
    var coders: [Generator.Element.CoderType] {
        return map { element in
            return Generator.Element.CoderType(value: element)
        }
    }
}

extension CollectionType where Generator.Element: Coder, Generator.Element.CodeableType: Codeable, Generator.Element.CodeableType.CoderType == Generator.Element {
    var objects: [Generator.Element.CodeableType] {
        return flatMap { $0.value }
    }
}
