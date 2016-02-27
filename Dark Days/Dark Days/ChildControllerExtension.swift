//
//  ChildControllerExtension.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

// TODO: Inject duration and rename to replaceChildViewController, pass in child view controller to replace. refactor remove into generic method, expose add and remove because you will use them. Go fuck yourself SwiftLint! You're helpful.

extension UIViewController {
    func switchToChildViewController(viewController: UIViewController) {
        func addViewController(viewController: UIViewController) {
            addChildViewController(viewController)
            view.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
        }
        
        if let currentChildController = childViewControllers.last {
            viewController.view.alpha = 0.0
            addViewController(viewController)
            
            UIView.animateWithDuration(0.4, animations: {
                currentChildController.view.alpha = 0.0
                viewController.view.alpha = 1.0
                },
                completion: { completed in
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
