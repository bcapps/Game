//
//  CharacterListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroListViewController: UITableViewController {
    var dataSource: ListDataSource<Item, UITableViewCell>?
    
    override func viewDidLoad() {
        let items: [Item] = ObjectProvider.objectsForJSON("Items")
        
        dataSource = ListDataSource(collection: items, configureCell: { cell, item in
            cell.textLabel?.text = item?.name
        })
        
        tableView.registerClass(UITableViewCell.self, type: .Cell)
        tableView.dataSource = dataSource
    }
}
