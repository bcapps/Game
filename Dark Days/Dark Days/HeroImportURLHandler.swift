//
//  HeroImportURLHandler.swift
//  Dark Days
//
//  Created by Andrew Harrison on 9/16/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class HeroImportURLHandler {
    
    static func canHandleURL(url: URL) -> Bool {
        return url.isFileURL && (url.pathExtension == ".hero")
    }
    
    static func handleHeroURL(url: URL, presentingViewController: UIViewController) -> Bool {
        let persistence = HeroPersistence()
        guard let hero = persistence.heroForURL(url) else { return false }
        
        guard !persistence.allPersistedHeroes().contains(where: { $0.uniqueID == hero.uniqueID }) else {
            showAskForPermissionAlertController(presentingViewController: presentingViewController)
            return false
        }
        
        persistence.persistHero(hero)
        
        return true
    }
    
    private static func showAskForPermissionAlertController(presentingViewController: UIViewController) {
        let alertController = UIAlertController(title: "Hero Already Exists", message: "It looks like the hero you are trying to import already exists. Are you sure you want to overwrite your local data with this import?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let proceedAction = UIAlertAction(title: "Yes", style: .default) { _ in
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(proceedAction)
        
        presentingViewController.show(alertController, sender: self)
    }
}
