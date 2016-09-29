//
//  HeroImportURLHandler.swift
//  Dark Days
//
//  Created by Andrew Harrison on 9/16/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class HeroImportURLHandler {
    typealias ImportCompletion = (Void) -> (Void)
    static func canHandleURL(url: URL) -> Bool {
        return url.isFileURL && (url.pathExtension == "hero")
    }
    
    static func handleHeroURL(url: URL, presentingViewController: UIViewController, completion: @escaping ImportCompletion) -> Bool {
        let persistence = HeroPersistence()
        guard let hero = persistence.heroForURL(url) else { return false }
        
        if let existingHero = persistence.allPersistedHeroes().filter({ $0.uniqueID == hero.uniqueID }).first {
            showAskForPermissionAlertController(presentingViewController: presentingViewController, existingHero: existingHero, newHero: hero, completion: completion)
            return true
        }
        
        persistence.persistHero(hero)
        completion()
        return true
    }
    
    private static func showAskForPermissionAlertController(presentingViewController: UIViewController, existingHero: Hero, newHero: Hero, completion: @escaping ImportCompletion) {
        let persistence = HeroPersistence()

        let alertController = UIAlertController(title: "Hero Already Exists", message: "It looks like the hero you are trying to import already exists. Are you sure you want to overwrite your local data with this import?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let proceedAction = UIAlertAction(title: "Yes", style: .default) { _ in
            persistence.removeHero(existingHero)
            persistence.persistHero(newHero)
            
            completion()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(proceedAction)
        
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}
