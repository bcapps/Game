//
//  SkillsListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/24/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol SkillsListViewControllerDelegate {
    func didSelectSkill(skillsListViewController: SkillsListViewController, skill: Skill)
}

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
    
    var skillsListDelegate: SkillsListViewControllerDelegate?
    
    private var dataSource: ListDataSource<Skill, InfoCell>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.customize()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let skill = dataSource?.collection[indexPath.row]
        
        if let skill = skill {
            skillsListDelegate?.didSelectSkill(self, skill: skill)
        }
    }
    
    private func descriptionForSkill(skill: Skill?) -> NSAttributedString {
        let description = NSMutableAttributedString()

        if let skill = skill {
            description.appendAttributedString(NSAttributedString.attributedStringWithBodyAttributes(skill.benefit))
            description.appendAttributedString(NSAttributedString(string: "\n\n"))
            description.appendAttributedString(NSAttributedString.attributedStringWithSmallAttributes(skill.explanation))
        }
        
        return description
    }
}
