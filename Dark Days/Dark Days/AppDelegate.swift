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
    fileprivate let crashManager = CrashManager(identifier: "a6e84183c21b46adbe5d00fb530f9342")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor.white
        
        guard let navigationController = window?.rootViewController as? UINavigationController else { return false }
        
        let heroListViewController = HeroListViewController(sections: [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes().sortedElementsByName)], delegate: nil)
        navigationController.pushViewController(heroListViewController, animated: false)
        
        return true
    }
}
