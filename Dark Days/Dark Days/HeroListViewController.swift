//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: UITableViewController {
    var heroes = [Hero]() {
        didSet {
            dataSource = ListDataSource(collection: heroes, configureCell: { cell, hero in
                cell.nameLabel?.text = hero?.name
                cell.leftImageView?.image = hero?.race.image
            })
            
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    
    private var dataSource: ListDataSource<Hero, LeftImageCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(LeftImageCell.nib, aClass: LeftImageCell.self, type: .Cell)
        tableView.rowHeight = 54.0
        
        tableView.customize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        heroes = HeroPersistence().allPersistedHeroes()
    }
}
