//
//  NameProvider.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

struct NameProvider {
    
    static let DwarfFemaleNames = NameProvider.arrayForFileName("RandomDwarfFemaleNames")
    static let DwarfMaleNames = NameProvider.arrayForFileName("RandomDwarfMaleNames")
    
    static let ElfFemaleNames = NameProvider.arrayForFileName("RandomElfFemaleNames")
    static let ElfMaleNames = NameProvider.arrayForFileName("RandomElfMaleNames")

    static let HumanFemaleNames = NameProvider.arrayForFileName("RandomHumanFemaleNames")
    static let HumanMaleNames = NameProvider.arrayForFileName("RandomHumanMaleNames")
    
    static let TavernNames = NameProvider.arrayForFileName("RandomTavernNames")
    static let TownNames = NameProvider.arrayForFileName("RandomTownNames")
    
    private static func arrayForFileName(name: String) -> NSArray {
        guard let URL = NSBundle.mainBundle().URLForResource(name, withExtension: "txt") else { return NSArray() }
        let content = try? NSString(contentsOfURL: URL, encoding: NSUTF8StringEncoding)
        
        return content?.componentsSeparatedByString("\n") ?? NSArray()
    }
}

extension NSArray {
    func randomObject() -> Element? {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        
        if randomIndex < self.count {
            return self.objectAtIndex(randomIndex)
        }
        
        return nil
    }
}
