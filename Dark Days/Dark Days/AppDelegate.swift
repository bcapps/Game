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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor.white
        navigationController = window?.rootViewController as? UINavigationController
        
        let heroListViewController = HeroListViewController(sections: [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes().sortedElementsByName)], delegate: nil)
        navigationController?.pushViewController(heroListViewController, animated: false)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let navigationController = navigationController else { return false }
        
        if HeroImportURLHandler.canHandleURL(url: url) {
            return HeroImportURLHandler.handleHeroURL(url: url, presentingViewController: navigationController)
        }
        
        return false
        
    }
}
