//
//  StoryboardLoading.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/27/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func heroCreationViewController() -> UIViewController? {
        return initialViewControllerFromStoryboardNamed("HeroCreation")
    }
    
    static func heroViewController() -> UIViewController? {
        return initialViewControllerFromStoryboardNamed("HeroViewController")
    }
    
    static func toolsViewController() -> UIViewController? {
        return initialViewControllerFromStoryboardNamed("DMToolkit")
    }
    
    private static func initialViewControllerFromStoryboardNamed(storyboardName: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle()).instantiateInitialViewController()
    }
}
