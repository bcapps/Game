//
//  NameProvider.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

struct NameProvider {
    
    static let DwarfFemaleNames = NSArray.arrayForFileName("RandomDwarfFemaleNames")
    static let DwarfMaleNames = NSArray.arrayForFileName("RandomDwarfMaleNames")
    
    static let ElfFemaleNames = NSArray.arrayForFileName("RandomElfFemaleNames")
    static let ElfMaleNames = NSArray.arrayForFileName("RandomElfMaleNames")

    static let HumanFemaleNames = NSArray.arrayForFileName("RandomHumanFemaleNames")
    static let HumanMaleNames = NSArray.arrayForFileName("RandomHumanMaleNames")
    
    static let TavernNames = NSArray.arrayForFileName("RandomTavernNames")
    static let TownNames = NSArray.arrayForFileName("RandomTownNames")
}

extension NSArray {
    
    static func arrayForFileName(name: String) -> NSArray {
        guard let URL = NSBundle.mainBundle().URLForResource(name, withExtension: "txt") else { return NSArray() }
        let content = try? NSString(contentsOfURL: URL, encoding: NSUTF8StringEncoding)
        
        return content?.componentsSeparatedByString("\n") ?? NSArray()
    }

    func randomObject() -> Element? {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        
        if randomIndex < self.count {
            return self.objectAtIndex(randomIndex)
        }
        
        return nil
    }
}
