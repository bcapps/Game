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
            dataSource = ListDataSource(collection: skills, configureCell: { cell, skill in
                cell.infoImage = skill?.image
                cell.nameText = skill?.name
                cell.infoAttributedText = self.descriptionForSkill(skill)
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
    
    private func descriptionForSkill(skill: Skill?) -> NSAttributedString? {
        if let skill = skill {
            return NSAttributedString.attributedStringWithBodyAttributes(skill.benefit + "\n" + skill.explanation)
        }
        
        return nil
    }
}
