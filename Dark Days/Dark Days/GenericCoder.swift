//
//  GenericCoder.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/20/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

class GenericCoder<T where T:Unarchiveable, T: Nameable, T: Decodable>: NSObject, Coder {
    typealias CodeableType = T
    
    var value: T?
    
    required init(value: T) {
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObjectForKey(Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.objectForJSONForName(T.JSONName, objectName: name)
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(value?.name, forKey: Keys.Name.rawValue)
    }
}

private enum Keys: String {
    case Name
}
