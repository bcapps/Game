//
//  RaceListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol RaceListViewControllerDelegate {
    func didSelectRace(raceListViewController: RaceListViewController, race: Race)
}

final class RaceListViewController: UITableViewController {
    
    var races = [Race]() {
        didSet {
            dataSource = ListDataSource(collection: races, configureCell: { cell, race in
                cell.nameText = race?.name
                cell.infoImage = race?.image
                
                if let race = race {
                    cell.infoAttributedText = self.raceInfoTextForRace(race)
                }
            })
            
            tableView.reloadData()
        }
    }
    
    var raceListDelegate: RaceListViewControllerDelegate?
    
    private var dataSource: ListDataSource<Race, InfoCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .Interactive
        tableView.customize()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let race = dataSource?.collection[indexPath.row]
        
        if let race = race {
            raceListDelegate?.didSelectRace(self, race: race)
        }
    }
    
    private func raceInfoTextForRace(race: Race) -> NSAttributedString {
        let infoAttributedString = NSMutableAttributedString()
        
        let explanation = NSAttributedString.attributedStringWithBodyAttributes(race.explanation)
        infoAttributedString.appendAttributedString(explanation)
        
        let benefitsHeading = NSAttributedString.attributedStringWithHeadingAttributes("\n\nBenefits")
        infoAttributedString.appendAttributedString(benefitsHeading)
        
        for string in race.benefits {
            infoAttributedString.appendAttributedString(NSAttributedString(string: "\n"))
            
            let benefitString = NSAttributedString.attributedStringWithBodyAttributes("• " + string)
            infoAttributedString.appendAttributedString(benefitString)
        }
        
        return infoAttributedString
    }
}
