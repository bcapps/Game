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
    
    static func objectForJSON<T: Decodable>(JSONName: String) -> T? {
        let JSONDictionary = JSONDictionaryForName(JSONName)
        
        if let JSONDictionary = JSONDictionary {
            return decodedObjectForJSONDictionary(JSONDictionary)
        }
        
        return nil
    }
    
    static func objectForJSONForName<T where T:Decodable, T:Nameable>(JSONName: String, objectName: String) -> T? {
        let objects: [T] = objectsForJSON(JSONName)
        
        for object in objects {
            if object.name == objectName {
                return object
            }
        }
        
        return nil
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