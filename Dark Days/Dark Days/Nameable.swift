//
//  Nameable.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

protocol Nameable {
    var name: String { get }
}

extension Collection where Iterator.Element: Nameable {
    var sortedElementsByName: [Iterator.Element] {
        return sorted { $0.name < $1.name }
    }
}
