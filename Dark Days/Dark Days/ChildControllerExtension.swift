//
//  ChildControllerExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIViewController {
    func addViewController(_ viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }

    func removeViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func replaceChildViewController(_ currentViewController: UIViewController?, newViewController: UIViewController?, animationDuration: TimeInterval) {
        
        if let newViewController = newViewController {
            newViewController.view.alpha = 0.0
            addViewController(newViewController)
        }
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            currentViewController?.view.alpha = 0.0
            newViewController?.view.alpha = 1.0
        }, completion: { completed in
            if let currentViewController = currentViewController {
                self.removeViewController(currentViewController)
            }
        }) 
    }    
}
