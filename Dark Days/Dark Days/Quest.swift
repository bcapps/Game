//
//  Quest.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/19/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Quest: Decodable, Codeable, Nameable, Equatable {
    typealias CoderType = GenericCoder<Quest>
    
    let name: String
    let description: String
    let rewards: [String]
    
    static func decode(json: AnyObject) throws -> Quest {
        return try Quest(name: json => "name",
                         description: json => "description",
                         rewards: json => "rewards")
    }
}

extension Quest: Unarchiveable {
    static var JSONName: String {
        return "Quests"
    }
}

func == (lhs: Quest, rhs: Quest) -> Bool {
    return lhs.name == rhs.name
}
