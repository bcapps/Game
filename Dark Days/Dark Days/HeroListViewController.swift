//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: UITableViewController {
    var dataSource: ListDataSource<Item, HeroCell>?
    
    override func viewDidLoad() {
        let items: [Item] = ObjectProvider.objectsForJSON("Items")
        
        dataSource = ListDataSource(collection: items, configureCell: { cell, item in
            cell.nameLabel?.text = item?.name
            cell.raceImageView?.image = UIImage(named: "Elf-Male")
        })
        
        tableView.registerClass(HeroCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.rowHeight = 104.0
        tableView.separatorInset = UIEdgeInsetsZero
    }
}
