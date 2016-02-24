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
            cell.infoImageView?.image = race?.image
            
            if let race = race {
                cell.infoTextView?.attributedText = self.raceInfoTextForRace(race)
            }
        })
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.customize()
    }
    
    private func raceInfoTextForRace(race: Race) -> NSAttributedString {
        let infoAttributedString = NSMutableAttributedString()
        
        let paragraphyStyle = NSMutableParagraphStyle()
        paragraphyStyle.lineHeightMultiple = 0.85
        
        if race.explanation.characters.count > 0 {
            let damageString = NSAttributedString(string: race.explanation, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
            
            infoAttributedString.appendAttributedString(damageString)
        }
        
        if race.benefits.count > 0 {
            infoAttributedString.appendAttributedString(NSAttributedString(string: "\n\nBenefits:", attributes: [NSFontAttributeName: UIFont.headingFont(), NSForegroundColorAttributeName: UIColor.headerTextColor()]))
            
            for string in race.benefits {
                infoAttributedString.appendAttributedString(NSAttributedString(string: "\n"))
                
                let benefitString = NSAttributedString(string: "• " + string, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
                
                infoAttributedString.appendAttributedString(benefitString)
            }
        }
        
        return infoAttributedString
    }
}
