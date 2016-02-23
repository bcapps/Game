//
//  ItemListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class ItemListViewController: UITableViewController {
    var dataSource: ListDataSource<Item, InfoCell>?

    override func viewDidLoad() {
        let items: [Item] = ObjectProvider.objectsForJSON("Items")
        
        dataSource = ListDataSource(collection: items, configureCell: { cell, item in
            cell.infoImageView?.image = UIImage(named: "Elf-Male")
            cell.infoNameLabel?.text = item?.name
            //cell.infoTextView?.text = item?.damage
        })
        
        tableView.backgroundColor = .backgroundColor()
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
}
