//
//  SkillsListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class SkillsListViewController: UITableViewController {
    var skills = [Skill]() {
        didSet {
            dataSource = ListDataSource(collection: skills, configureCell: { cell, item in
                if let item = item {
                    cell.infoImage = UIImage(named: "Elf")
                    cell.nameText = item.name
                    //cell.infoAttributedText = self.descriptionForItem(item)
                }
            })
            
            tableView.reloadData()
        }
    }
    
    private var dataSource: ListDataSource<Skill, InfoCell>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.customize()
    }
}
