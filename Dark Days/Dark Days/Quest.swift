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
    typealias CoderType = QuestCoder
    
    let name: String
    let explanation: String
    let notes: String
    let rewards: [String]
    let completed: Bool
    
    static func decode(_ json: Any) throws -> Quest {
        return try Quest(name: json => "name",
                         explanation: json => "explanation",
                         notes: json => "notes",
                         rewards: json => "rewards",
                         completed: json =>? "completed" ?? false)
    }
}

func == (lhs: Quest, rhs: Quest) -> Bool {
    return lhs.name == rhs.name
}

final class QuestCoder: NSObject, Coder {
    typealias Codeable = Quest
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: Quest?
    
    init(value: Quest) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        let rawName = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String
        
        guard let name = rawName else { return nil }
        
        value = ObjectProvider.questForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
