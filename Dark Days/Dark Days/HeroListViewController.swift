//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: ListViewController<Hero> {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addButtonTapped"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.objects = HeroPersistence().allPersistedHeroes()
    }
    
    internal func addButtonTapped() {        
        if let heroCreationFlow = UIStoryboard.heroCreationViewController() {
            self.navigationController?.presentViewController(heroCreationFlow, animated: true, completion: nil)
        }
    }
}
