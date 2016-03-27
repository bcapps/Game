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
    
    static func objectsForJSON<T: Decodable>(JSONName: String) -> [T] {
        guard let JSONArray = JSONArrayForName(JSONName) else { return [T]() }
        
        return JSONArray.flatMap { return try? T.decode($0)}
    }
    
    static func sortedObjectsForJSON<T: Decodable where T: Nameable>(JSONName: String) -> [T] {
        return objectsForJSON(JSONName).sortedElementsByName
    }
    
    static func objectForJSON<T: Decodable>(JSONName: String) -> T? {
        guard let JSONDictionary = JSONDictionaryForName(JSONName) else { return nil }
        
        return try? T.decode(JSONDictionary)
    }
    
    static func statForName(name: String) -> Stat? {
        return objectForJSONForName("Stats", objectName: name)
    }
    
    static func raceForName(name: String) -> Race? {
        return objectForJSONForName("Races", objectName: name)
    }
    
    static func skillForName(name: String) -> Skill? {
        return objectForJSONForName("Skills", objectName: name)
    }
    
    static func itemForName(name: String) -> Item? {
        return objectForJSONForName("Items", objectName: name)
    }
    
    static func floorForName(name: String) -> Floor? {
        return objectForJSONForName("Floors", objectName: name)
    }
    
    static func godForName(name: String) -> God? {
        return objectForJSONForName("Gods", objectName: name)
    }
    
    static func monsterForName(name: String) -> Monster? {
        return objectForJSONForName("Monsters", objectName: name)
    }
    
    static func magicTypeForName(name: String) -> MagicType? {
        return objectForJSONForName("MagicTypes", objectName: name)
    }
    
    static func spellForName(name: String) -> Spell? {
        return objectForJSONForName("Spells", objectName: name)
    }
    
    private static func objectForJSONForName<T where T:Decodable, T:Nameable>(JSONName: String, objectName: String) -> T? {
        let objects: [T] = objectsForJSON(JSONName)
        
        return objects.filter({$0.name == objectName}).first
    }
    
    private static func JSONArrayForName(JSONName: String) -> [[String: AnyObject]]? {
        return JSONObjectForName(JSONName) ?? []
    }
    
    private static func JSONDictionaryForName(JSONName: String) -> [String: AnyObject]? {
        return JSONObjectForName(JSONName) ?? [String: AnyObject]()
    }
    
    private static func JSONObjectForName<T>(JSONName: String) -> T?? {
        guard let path = NSBundle.mainBundle().pathForResource(JSONName, ofType: "json") else { return nil }
        guard let jsonData = NSData(contentsOfFile: path) else { return nil }
        
        return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? T
    }
}
