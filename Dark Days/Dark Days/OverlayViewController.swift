//
//  OverlayViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 3/12/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {
    
    let insetViewController: UITableViewController
    
    init(insetViewController: UITableViewController) {
        self.insetViewController = insetViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.insetViewController = UITableViewController()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        
        insetViewController.tableView.separatorStyle = .None
        insetViewController.tableView.scrollEnabled = false
        insetViewController.tableView.userInteractionEnabled = false
        insetViewController.view.layer.cornerRadius = 12
        
        var frame = CGRectInset(view.frame, 40, 0)
        frame.size.height = insetViewController.tableView.contentSize.height
        insetViewController.view.frame = frame
        insetViewController.view.backgroundColor = .redColor()
        
        insetViewController.view.alpha = 0.0
        addViewController(insetViewController)
        
        UIView.animateWithDuration(0.5) {
            self.insetViewController.view.alpha = 1.0
        }
        
        let tapDismissGesture = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
        view.addGestureRecognizer(tapDismissGesture)
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.5) {
            self.replaceChildViewController(self, newViewController: nil, animationDuration: 0.5)
        }
    }
}
