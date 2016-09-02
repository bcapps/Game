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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.tintColor = UIColor.whiteColor()
        
        guard let navigationController = window?.rootViewController as? UINavigationController else { return false }
        
        let heroListViewController = HeroListViewController(sections: [SectionList(sectionTitle: nil, objects: HeroPersistence().allPersistedHeroes().sortedElementsByName)], delegate: nil)
        navigationController.pushViewController(heroListViewController, animated: false)
        
        return true
    }
}
