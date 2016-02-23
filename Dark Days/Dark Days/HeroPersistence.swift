//
//  HeroPersistence.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class HeroPersistence {
    
    func persistHero(hero: Hero) {
        let archivedHeroCoder = NSKeyedArchiver.archivedDataWithRootObject(HeroCoder(value: hero))
        
        archivedHeroCoder.writeToFile(pathForHero(hero), atomically: true)
    }
    
    func removeHero(hero: Hero) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(pathForHero(hero))
        } catch {}
    }
    
    func allPersistedHeroes() -> [Hero] {
        var heroes = [Hero]()

        do {
            let heroURLs = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(NSURL(fileURLWithPath: heroDirectoryPath()), includingPropertiesForKeys: nil, options: .SkipsHiddenFiles)
            
            for heroURL in heroURLs {
                if let hero = heroForURL(heroURL) {
                    heroes.append(hero)
                }
            }
        } catch {}
        
        return heroes
    }
    
    private func heroForURL(URL: NSURL) -> Hero? {
        if let path = URL.path {
            let unarchivedHeroCoder = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? HeroCoder
            
            return unarchivedHeroCoder?.value
        }
        
        return nil
    }
    
    private func pathForHero(hero: Hero) -> String {
        return heroDirectoryPath().stringByAppendingString(hero.uniqueID + ".hero")
    }
    
    private func heroDirectoryPath() -> String {
        let heroesPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/Heroes/")
        
        if NSFileManager.defaultManager().fileExistsAtPath(heroesPath) == false {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(heroesPath, withIntermediateDirectories: false, attributes: nil)
            } catch {}
        }
        
        return heroesPath
    }
}
