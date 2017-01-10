//
//  NameProvider.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

struct NameProvider {
    
    static let DwarfFemaleNames = ObjectProvider.stringJSONArray(forName: "RandomDwarfFemaleNames")
    static let DwarfMaleNames = ObjectProvider.stringJSONArray(forName: "RandomDwarfMaleNames")
    
    static let ElfFemaleNames = ObjectProvider.stringJSONArray(forName: "RandomElfFemaleNames")
    static let ElfMaleNames = ObjectProvider.stringJSONArray(forName: "RandomElfMaleNames")

    static let HumanFemaleNames = ObjectProvider.stringJSONArray(forName: "RandomHumanFemaleNames")
    static let HumanMaleNames = ObjectProvider.stringJSONArray(forName: "RandomHumanMaleNames")
    
    static let TavernNames = ObjectProvider.stringJSONArray(forName: "RandomTavernNames")
    static let TownNames = ObjectProvider.stringJSONArray(forName: "RandomTownNames")
}

extension ObjectProvider {
    
    static func stringJSONArray(forName name: String) -> [String] {
        let JSON: [String]?? = ObjectProvider.JSONObjectForName(name)
        
        return (JSON ?? []) ?? []
    }
}

extension Array {
    
    func randomObject() -> NSArray.Element? {
        return (self as NSArray).randomObject()
    }
}

extension NSArray {
    
    static func arrayForFileName(_ name: String) -> NSArray {
        guard let URL = Bundle.main.url(forResource: name, withExtension: "txt") else { return NSArray() }
        let content = try? NSString(contentsOf: URL, encoding: String.Encoding.utf8.rawValue)
        
        return content?.components(separatedBy: "\n") as NSArray? ?? NSArray()
    }

    func randomObject() -> Element? {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        
        if randomIndex < self.count {
            return self.object(at: randomIndex)
        }
        
        return nil
    }
}
