//
//  Note.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Note: Decodable, Nameable {
    let name: String
    let explanation: String
    let completed: Bool
    
    static func decode(json: AnyObject) throws -> Note {
        return try Note(name: json => "name",
                        explanation: json => "explanation",
                        completed: json =>? "completed" ?? false)
    }
}
