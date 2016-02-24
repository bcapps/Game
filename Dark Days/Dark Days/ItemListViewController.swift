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
        super.viewDidLoad()
        
        let items: [Item] = ObjectProvider.objectsForJSON("Items")
        
        dataSource = ListDataSource(collection: items, configureCell: { cell, item in
            if let item = item {
                cell.infoImage = UIImage(named: "Elf")
                cell.nameText = item.name
                cell.infoAttributedText = self.descriptionForItem(item)
            }
        })
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.customize()
    }
    
    private func descriptionForItem(item: Item) -> NSAttributedString {
        let description = NSMutableAttributedString()
        
        let paragraphyStyle = NSMutableParagraphStyle()
        paragraphyStyle.lineHeightMultiple = 0.85
                
        if item.damage.characters.count > 0 {
            let damageString = NSAttributedString(string: "Damage: " + item.damage, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()])
            
            description.appendAttributedString(damageString)
        }
        
        if item.effects.characters.count > 0 {
            let effectsString = NSAttributedString(string: "\n\n" + item.effects, attributes: [NSFontAttributeName: UIFont.bodyFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor(), NSParagraphStyleAttributeName: paragraphyStyle])
            
            description.appendAttributedString(effectsString)
        }
        
        if item.flavor.characters.count > 0 {
            let flavorString = NSAttributedString(string: "\n\n" + item.flavor, attributes: [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.sideTextColor(), NSParagraphStyleAttributeName: paragraphyStyle])
            
            description.appendAttributedString(flavorString)
        }
        
        return description
    }
}
