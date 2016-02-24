//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: UITableViewController {
    var dataSource: ListDataSource<Hero, LeftImageCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heroes: [Hero] = HeroPersistence().allPersistedHeroes()
        
        dataSource = ListDataSource(collection: heroes, configureCell: { cell, hero in
            cell.nameLabel?.text = hero?.name
            cell.leftImageView?.image = hero?.race.image
        })
        
        tableView.registerNib(LeftImageCell.nib, aClass: LeftImageCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.rowHeight = 54.0
        
        tableView.customize()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? UINavigationController {
            if let rootViewController = destination.viewControllers.first as? RaceListViewController {
                print("H")
            }
        }
    }
}
