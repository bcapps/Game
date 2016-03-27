//
//  CollectionTypeNotEmptyExtension.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/26/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

extension CollectionType {

    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String {
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
