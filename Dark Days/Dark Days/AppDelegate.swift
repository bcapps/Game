//
//  AppDelegate.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let crashManager = CrashManager(identifier: "a6e84183c21b46adbe5d00fb530f9342")
    private var navigationController: UINavigationController?
    private var heroListViewController: HeroListViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor.white
        navigationController = window?.rootViewController as? UINavigationController
        
        heroListViewController = HeroListViewController(sections: HeroPersistence().allPersistedHeroes().sectionedHeroes, delegate: nil)
                
        guard let heroListViewController = heroListViewController else { return false }
        navigationController?.pushViewController(heroListViewController, animated: false)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let navigationController = navigationController else { return false }
        
        if HeroImportURLHandler.canHandleURL(url: url) {
            return HeroImportURLHandler.handleHeroURL(url: url, presentingViewController: navigationController, completion: {
                self.heroListViewController?.refreshHeroList()
            })
        }
        
        return false
        
    }
}

extension Array where Element: Hero {
    var sectionedHeroes: [SectionList<Hero>] {
        var sections = [SectionList<Hero>]()
        let campaigns = ObjectProvider.sortedObjectsForJSON("Campaigns") as [Campaign]
        
        for campaign in campaigns {
            let heroes: [Hero] = self.filter({ $0.campaign == campaign }).sortedElementsByName
            
            if campaigns.isNotEmpty {
                sections.append(SectionList(sectionTitle: campaign.name, objects: heroes))
            }
        }
        
        return sections
    }
}
