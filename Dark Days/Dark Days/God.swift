//
//  God.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct God: Decodable, Nameable, Codeable {
    typealias CoderType = GenericCoder<God>

    let name: String
    let background: String
    let responsibilties: [String]
    
    static func decode(json: AnyObject) throws -> God {
        return try God(
            name: json => "name",
            background: json => "background",
            responsibilties: json => "responsibilities"
        )
    }
}

extension God: Unarchiveable {
    static var JSONName: String {
        return "Gods"
    }
}
