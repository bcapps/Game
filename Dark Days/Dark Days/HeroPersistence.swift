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
    
    fileprivate let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    init(persistenceFilename: String = "Heroes") {
        self.persistenceFilename = persistenceFilename
    }
    
    func persistHero(_ hero: Hero) {
        let archivedHeroCoder = NSKeyedArchiver.archivedData(withRootObject: HeroCoder(value: hero))
        
        try? archivedHeroCoder.write(to: URLForHero(hero), options: [.atomic])
    }
    
    func removeHero(_ hero: Hero) {
        _ = try? FileManager.default.removeItem(at: URLForHero(hero))
    }
    
    func URLForHero(_ hero: Hero) -> URL {
        return heroDirectoryURL().appendingPathComponent(hero.uniqueID + ".hero")
    }
    
    func allPersistedHeroes() -> [Hero] {
        guard let heroURLs = try? FileManager.default.contentsOfDirectory(at: heroDirectoryURL(), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: 0)) else { return [] }
        
        return heroURLs.flatMap { return heroForURL($0) }
    }
    
    func heroForURL(_ URL: Foundation.URL) -> Hero? {
        let unarchivedHeroCoder = NSKeyedUnarchiver.unarchiveObject(withFile: URL.path) as? HeroCoder
        
        return unarchivedHeroCoder?.value
    }
    
    fileprivate func heroDirectoryURL() -> URL {
        let heroDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(persistenceFilename, isDirectory: true)
        
        guard let directoryPath = heroDirectoryURL?.path else {
            assertionFailure()
            return URL(fileURLWithPath: "")
        }
        
        if FileManager.default.fileExists(atPath: directoryPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {print("Hero Directory Not Created")}
        }
        
        return heroDirectoryURL ?? URL(fileURLWithPath: "")
    }
}
