//
//  RaceListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class RaceListViewController: UITableViewController {
    var dataSource: ListDataSource<Race, InfoCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let races: [Race] = ObjectProvider.objectsForJSON("Races")
        
        dataSource = ListDataSource(collection: races, configureCell: { cell, race in
            cell.infoNameLabel?.text = race?.name
            //cell.infoImageView?.image = race?.image
            cell.infoTextView?.text = race?.explanation
        })
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.rowHeight = 54.0
        
        tableView.customize()
    }
}
