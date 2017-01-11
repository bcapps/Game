//
//  Campaign.swift
//  Dark Days
//
//  Created by Andrew Harrison on 1/10/17.
//  Copyright © 2017 Lickability. All rights reserved.
//

import Foundation
import Decodable

struct Campaign: Decodable, Codeable, Nameable, Equatable {
    typealias CoderType = CampaignCoder

    let name: String
    let explanation: String
    
    static func decode(_ json: Any) throws -> Campaign {
        return try Campaign(name: json => "name",
                            explanation: json => "explanation")
    }
}

func == (lhs: Campaign, rhs: Campaign) -> Bool {
    return lhs.name == rhs.name
}

final class CampaignCoder: NSObject, Coder {
    typealias Codeable = Campaign
    
    fileprivate enum Keys: String {
        case Name
    }
    
    var value: Campaign?
    
    init(value: Campaign) {
        self.value = value
        super.init()
    }
    
    init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.Name.rawValue) as? String else { return nil }
        
        value = ObjectProvider.campaignForName(name)
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.name, forKey: Keys.Name.rawValue)
    }
}
