//
//  HeroPersistence.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class HeroPersistence {
    
    let persistenceFilename: String
    
    init(persistenceFilename: String = "Heroes") {
        self.persistenceFilename = persistenceFilename
    }
    
    func persistHero(hero: Hero) {
        let archivedHeroCoder = NSKeyedArchiver.archivedDataWithRootObject(HeroCoder(value: hero))
        
        archivedHeroCoder.writeToURL(URLForHero(hero), atomically: true)
    }
    
    func removeHero(hero: Hero) {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(URLForHero(hero))
        } catch {print("Hero not removed.")}
    }
    
    func allPersistedHeroes() -> [Hero] {
        var heroes = [Hero]()

        do {
            let heroURLs = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(heroDirectoryURL(), includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions(rawValue: 0))
            
            for heroURL in heroURLs {
                guard let hero = heroForURL(heroURL) else { continue }
                
                heroes.append(hero)
            }
        } catch {}
        
        return heroes
    }
    
    private func heroForURL(URL: NSURL) -> Hero? {
        guard let path = URL.path else { return nil }
        
        let unarchivedHeroCoder = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? HeroCoder
        
        return unarchivedHeroCoder?.value
    }
    
    private func URLForHero(hero: Hero) -> NSURL {
        return heroDirectoryURL().URLByAppendingPathComponent(hero.uniqueID + ".hero")
    }
    
    private func heroDirectoryURL() -> NSURL {
        let heroDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first?.URLByAppendingPathComponent(persistenceFilename, isDirectory: true)
        
        guard let directoryPath = heroDirectoryURL?.path else {
            assertionFailure()
            return NSURL()
        }
        
        if NSFileManager.defaultManager().fileExistsAtPath(directoryPath) == false {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {print("Hero Directory Not Created")}
        }
        
        return heroDirectoryURL ?? NSURL()
    }
}
