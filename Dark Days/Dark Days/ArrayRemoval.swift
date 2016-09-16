//
//  ArrayRemoval.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/26/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        guard let index = self.index(of: object) else { return }
        
        self.remove(at: index)
    }
}
