//
//  HeroCreationViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

public class HeroCreationViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor()
        nameField.backgroundColor = .backgroundColor()
        nameField.textColor = .headerTextColor()
        nameField.font = .smallFont()
        nameField.attributedPlaceholder = NSAttributedString.attributedStringWithSmallAttributes("Hero Name")
        
        transitionToRaceList()
    }
    
    private func transitionToItemList() {
        let itemListViewController = ItemListViewController()
        itemListViewController.items = ObjectProvider.objectsForJSON("Items")
        
        switchToViewController(itemListViewController)
    }
    
    private func transitionToRaceList() {
        let raceListViewController = RaceListViewController()
        raceListViewController.races = ObjectProvider.objectsForJSON("Races")
        
        switchToViewController(raceListViewController)
    }
    
    private func switchToViewController(viewController: UIViewController) {
        setFrameForChildViewController(viewController)
        switchToChildViewController(viewController)
    }
    
    private func setFrameForChildViewController(viewController: UIViewController) {
        var frame = viewController.view.frame
        frame.origin.y = CGRectGetMaxY(nameField.frame) + 10
        frame.size.height -= CGRectGetMaxY(nameField.frame) + 10
        viewController.view.frame = frame
    }
}
