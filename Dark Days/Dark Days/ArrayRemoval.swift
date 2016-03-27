//
//  ArrayRemoval.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/26/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        guard let index = self.indexOf(object) else { return }
        
        self.removeAtIndex(index)
    }
}
