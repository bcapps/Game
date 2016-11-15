//
//  StoryboardLoading.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func heroCreationViewController() -> UINavigationController? {
        return initialViewControllerFromStoryboardNamed("HeroCreation") as? UINavigationController
    }
    
    static func heroViewController() -> HeroViewController? {
        return initialViewControllerFromStoryboardNamed("HeroViewController") as? HeroViewController
    }
    
    static func toolsViewController() -> UINavigationController? {
        return initialViewControllerFromStoryboardNamed("DMToolkit") as? UINavigationController
    }
    
    static func sendGoldViewController() -> SendGoldViewController? {
        return initialViewControllerFromStoryboardNamed("SendGold") as? SendGoldViewController
    }
    static func namesViewController() -> NamesViewController? {
        return initialViewControllerFromStoryboardNamed("Names") as? NamesViewController
    }
    
    static func nameHeroViewController() -> NameHeroViewController? {
        return initialViewControllerFromStoryboardNamed("NameHero") as? NameHeroViewController
    }
    
    static func monsterViewController() -> MonsterViewController? {
        return initialViewControllerFromStoryboardNamed("MonsterViewController") as? MonsterViewController
    }
    
    static func effectsViewController() -> EffectsTableViewController? {
        return initialViewControllerFromStoryboardNamed("EffectsViewController") as? EffectsTableViewController
    }
    
    static func mapViewController() -> MapViewController? {
        return initialViewControllerFromStoryboardNamed("MapViewController") as? MapViewController
    }
    
    static func statusEffectsViewController() -> StatusesCollectionViewController? {
        return initialViewControllerFromStoryboardNamed("StatusesCollectionViewController") as? StatusesCollectionViewController
    }
    
    fileprivate static func initialViewControllerFromStoryboardNamed(_ storyboardName: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateInitialViewController()
    }
}
