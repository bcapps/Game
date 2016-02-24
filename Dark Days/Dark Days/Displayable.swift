//
//  Displayable.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol Displayable {
    var title: String? { get }
    var information: String? { get }
    var additionalInfoTitle: String? { get }
    var additionalInfo: String? { get }
    var subtext: String? { get }
    var image: UIImage? { get }
}

extension Displayable {
    var image: UIImage? {
        get {
            return UIImage(named: title ?? "")
        }
    }
}

extension Hero: Displayable {
    var title: String? {
        return name
    }
    
    var information: String? {
        return nil
    }
    
    var additionalInfo: String? {
        return nil
    }
    
    var additionalInfoTitle: String? {
        return nil
    }
    
    var subtext: String? {
        return nil
    }
    
    var image: UIImage? {
        return race.image
    }
}

extension Race: Displayable {
    var title: String? {
        return name
    }
    
    var information: String? {
        return explanation
    }
    
    var additionalInfoTitle: String? {
        return "Benefits"
    }
    
    var subtext: String? {
        return nil
    }
    
    var additionalInfo: String? {
        return benefits.joinWithSeparator("\n")
    }
}

extension Item: Displayable {
    var title: String? {
        return name
    }
    
    var information: String? {
        return damage
    }
    
    var additionalInfoTitle: String? {
        return nil
    }

    var subtext: String? {
        return flavor
    }
    
    var additionalInfo: String? {
        return effects
    }
}

extension Skill: Displayable {
    var title: String? {
        return name
    }
    
    var information: String? {
        return benefit
    }
    
    var additionalInfoTitle: String? {
        return nil
    }
    
    var subtext: String? {
        return explanation
    }
    
    var additionalInfo: String? {
        return nil
    }
}

extension Stat: Displayable {
    var title: String? {
        return name
    }
    
    var information: String? {
        return explanation
    }
    
    var additionalInfoTitle: String? {
        return nil
    }
    
    var subtext: String? {
        return benefits.joinWithSeparator("\n")
    }
    
    var additionalInfo: String? {
        return nil
    }
}
