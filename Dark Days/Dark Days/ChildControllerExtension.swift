//
//  ChildControllerExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

extension UIViewController {
    func switchToChildViewController(viewController: UIViewController) {
        func addViewController(viewController: UIViewController) {
            addChildViewController(viewController)
            view.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
        }
        
        if let currentChildController = childViewControllers.first {
            viewController.view.alpha = 0.0
            addViewController(viewController)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                currentChildController.view.alpha = 0.0
                viewController.view.alpha = 1.0
                },
                completion: { (completed) -> Void in
                    currentChildController.willMoveToParentViewController(nil)
                    currentChildController.view.removeFromSuperview()
                    currentChildController.removeFromParentViewController()
            })
        }
        else {
            addViewController(viewController)
        }
    }
}
