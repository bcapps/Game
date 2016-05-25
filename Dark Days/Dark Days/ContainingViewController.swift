//
//  File.swift
//  Dark Days
//
//  Created by Andrew Harrison on 4/1/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

class ContainingViewController: UIViewController {
    
    let containedViewController: UITableViewController
    let footerView: UIView?
    let footerViewBorder = BorderGenerator.newTopBorder(0, height: 0)
    let insetView = UIView()
    
    init(containedViewController: UITableViewController, footerView: UIView?) {
        self.containedViewController = containedViewController
        self.footerView = footerView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.containedViewController = UITableViewController()
        self.footerView = UIView()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        
        insetView.layer.cornerRadius = 12.0
        insetView.layer.borderWidth = 1.0
        insetView.layer.borderColor = UIColor.grayColor().CGColor
        
        view.addSubview(insetView)
        
        containedViewController.tableView.separatorStyle = .None
        containedViewController.tableView.allowsSelection = false
        
        addChildViewController(containedViewController)
        insetView.addSubview(containedViewController.view)
        containedViewController.didMoveToParentViewController(self)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: .dismissOverlay)
        view.addGestureRecognizer(tapRecognizer)
        view.userInteractionEnabled = true
        
        if let footerView = footerView {
            insetView.addSubview(footerView)
            footerView.layer.addSublayer(footerViewBorder)
            containedViewController.tableView.contentInset.bottom = 15
        }
    }
    
    func dismissOverlay() {
        UIView.animateWithDuration(0.35, animations: {
            self.view.alpha = 0.0
        }) { (completed) in
            self.removeViewController(self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        var frame = view.bounds.insetBy(dx: 50, dy: 85)
        frame.origin.y = 50
        
        insetView.frame = frame
        
        containedViewController.view.frame = insetView.bounds
        let height: CGFloat = 40.0
        footerView?.frame = CGRect(x: 0, y: insetView.frame.size.height - height, width: insetView.frame.size.width, height: height)
        footerViewBorder.frame = CGRect(x: 0, y: 0, width: footerView?.frame.size.width ?? 0, height: 1.0)
    }
}

private class BorderGenerator {
    static func newTopBorder(width: CGFloat, height: CGFloat) -> CALayer {
        let border: CALayer = CALayer()
        border.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        border.backgroundColor = UIColor.grayColor().CGColor
        
        return border
    }
}

private extension Selector {
    static let dismissOverlay = #selector(ContainingViewController.dismissOverlay)
}
