//
//  AppDelegate.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/21/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window?.tintColor = UIColor.whiteColor()
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            let heroListViewController = HeroListViewController(objects: HeroPersistence().allPersistedHeroes(), delegate: nil)
            
            navigationController.pushViewController(heroListViewController, animated: false)
        }
        
        return true
    }
}

