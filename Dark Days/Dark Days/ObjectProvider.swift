//
//  ObjectProvider.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation
import Decodable

final class ObjectProvider {
    
    static func objectsForJSON<T: Decodable>(_ JSONName: String) -> [T] {
        guard let JSONArray = JSONArrayForName(JSONName) else { return [T]() }

        return JSONArray.flatMap { return try? T.decode($0)}
    }
    
    static func sortedObjectsForJSON<T: Decodable & Nameable>(_ JSONName: String) -> [T] {
        return objectsForJSON(JSONName).sortedElementsByName
    }
    
    static func statForName(_ name: String) -> Stat? {
        return objectForJSONForName("Stats", objectName: name)
    }
    
    static func raceForName(_ name: String) -> Race? {
        return objectForJSONForName("Races", objectName: name)
    }
    
    static func skillForName(_ name: String) -> Skill? {
        return objectForJSONForName("Skills", objectName: name)
    }
    
    static func itemForName(_ name: String) -> Item? {
        return objectForJSONForName("Items", objectName: name)
    }
    
    static func townForName(_ name: String) -> Town? {
        return objectForJSONForName("Towns", objectName: name)
    }
    
    static func godForName(_ name: String) -> God? {
        return objectForJSONForName("Gods", objectName: name)
    }
    
    static func monsterForName(_ name: String) -> Monster? {
        return objectForJSONForName("Monsters", objectName: name)
    }
    
    static func magicTypeForName(_ name: String) -> MagicType? {
        return objectForJSONForName("MagicTypes", objectName: name)
    }
    
    static func spellForName(_ name: String) -> Spell? {
        return objectForJSONForName("Spells", objectName: name)
    }
    
    static func questForName(_ name: String) -> Quest? {
        return objectForJSONForName("Quests", objectName: name)
    }
    
    static func merchantForName(_ name: String) -> Merchant? {
        return objectForJSONForName("Merchants", objectName: name)
    }
    
    static func monsterTraitForName(_ name: String) -> MonsterTrait? {
        return objectForJSONForName("MonsterTraits", objectName: name)
    }
    
    static func statusEffectForName(_ name: String) -> StatusEffect? {
        return objectForJSONForName("StatusEffects", objectName: name)
    }
    
    static func objectForJSONForName<T: Decodable & Nameable>(_ JSONName: String, objectName: String) -> T? {
        let objects: [T] = objectsForJSON(JSONName)
        
        return objects.filter({$0.name == objectName}).first
    }
    
    static func JSONArrayForName(_ JSONName: String) -> [[String: AnyObject]]? {
        return JSONObjectForName(JSONName) ?? []
    }
    
    static func JSONDictionaryForName(_ JSONName: String) -> [String: AnyObject]? {
        return JSONObjectForName(JSONName) ?? [String: AnyObject]()
    }
    
    static func JSONObjectForName<T>(_ JSONName: String) -> T?? {
        guard let path = Bundle.main.path(forResource: JSONName, ofType: "json") else { return nil }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        
        return try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? T
    }
}
