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

extension Collection where Iterator.Element: Codeable, Iterator.Element.CoderType.CodeableType == Iterator.Element, Iterator.Element.CoderType: Coder {
    var coders: [Iterator.Element.CoderType] {
        return map { element in
            return Iterator.Element.CoderType(value: element)
        }
    }
}

extension Collection where Iterator.Element: Coder, Iterator.Element.CodeableType: Codeable {
    var objects: [Iterator.Element.CodeableType] {
        return flatMap { $0.value }
    }
}
