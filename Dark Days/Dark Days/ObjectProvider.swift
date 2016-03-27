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
        let JSONArray = JSONArrayForName(JSONName)
        
        var objects = [T]()
        
        if let JSONArray = JSONArray {
            for JSONDictionary in JSONArray {
                if let decodedObject: T = decodedObjectForJSONDictionary(JSONDictionary) {
                    objects.append(decodedObject)
                }
            }
        }
        
        return objects
    }
    
    static func sortedObjectsForJSON<T: Decodable where T: Nameable>(JSONName: String) -> [T] {
        return objectsForJSON(JSONName).sortedElementsByName
    }
    
    static func objectForJSON<T: Decodable>(JSONName: String) -> T? {
        let JSONDictionary = JSONDictionaryForName(JSONName)
        
        if let JSONDictionary = JSONDictionary {
            return decodedObjectForJSONDictionary(JSONDictionary)
        }
        
        return nil
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
    
    private static func decodedObjectForJSONDictionary<T: Decodable>(JSONDictionary: [String: AnyObject]) -> T? {
        do {
            return try T.decode(JSONDictionary)
        } catch {}
        
        return nil
    }
    
    private static func JSONArrayForName(JSONName: String) -> [[String: AnyObject]]? {
        return JSONObjectForName(JSONName)
    }
    
    private static func JSONDictionaryForName(JSONName: String) -> [String: AnyObject]? {
        return JSONObjectForName(JSONName)
    }
    
    private static func JSONObjectForName<T>(JSONName: String) -> T? {
        if let path = NSBundle.mainBundle().pathForResource(JSONName, ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    return try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? T
                } catch {}
                
                return nil
            }
        }
        
        return nil
    }
}
