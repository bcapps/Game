//
//  ChildControllerExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIViewController {
    func addViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }

    func removeViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func replaceChildViewController(currentViewController: UIViewController, newViewController: UIViewController, animationDuration: NSTimeInterval) {
        newViewController.view.alpha = 0.0
        addViewController(newViewController)
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            currentViewController.view.alpha = 0.0
            newViewController.view.alpha = 1.0
        }) { completed in
            self.removeViewController(currentViewController)
        }
    }    
}
