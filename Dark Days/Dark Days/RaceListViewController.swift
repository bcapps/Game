//
//  RaceListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class RaceListViewController: UITableViewController {
    var dataSource: ListDataSource<Race, LeftImageCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let races: [Race] = ObjectProvider.objectsForJSON("Races")
        
        dataSource = ListDataSource(collection: races, configureCell: { cell, race in
            cell.nameLabel?.text = race?.name
            cell.leftImageView?.image = race?.image
        })
        
        tableView.registerNib(LeftImageCell.nib, aClass: LeftImageCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.rowHeight = 54.0
        
        tableView.customize()
    }
}
