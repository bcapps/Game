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
            let heroPaths = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(heroDirectoryPath())
            
            for heroPath in heroPaths {
                if let hero = heroForPath(heroPath) {
                    heroes.append(hero)
                }
            }
        } catch {}
        
        return heroes
    }
    
    private func heroForPath(path: String) -> Hero? {
        let unarchivedHeroCoder = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? HeroCoder
        
        return unarchivedHeroCoder?.value
    }
    
    private func pathForHero(hero: Hero) -> String {
        return heroDirectoryPath().stringByAppendingString(hero.uniqueID)
    }
    
    private func heroDirectoryPath() -> String {
        let heroesPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/Heroes")
        
        if NSFileManager.defaultManager().fileExistsAtPath(heroesPath) == false {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(heroesPath, withIntermediateDirectories: false, attributes: nil)
            } catch {}
        }
        
        return heroesPath
    }
}
