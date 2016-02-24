//
//  ItemListViewController.swift
//  Dark Days
//
//  Created by Harrison, Andrew on 2/23/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

protocol ItemListViewControllerDelegate {
    func didSelectItem(itemListViewController: ItemListViewController, item: Item)
}

final class ItemListViewController: UITableViewController {
    var items = [Item]() {
        didSet {
            dataSource = ListDataSource(collection: items, configureCell: { cell, item in
                if let item = item {
                    cell.infoImage = UIImage(named: "Elf")
                    cell.nameText = item.name
                    cell.infoAttributedText = self.descriptionForItem(item)
                }
            })
            
            tableView.reloadData()
        }
    }
    
    var itemListDelegate: ItemListViewControllerDelegate?
    
    private var dataSource: ListDataSource<Item, InfoCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(InfoCell.nib, aClass: InfoCell.self, type: .Cell)
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.customize()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource?.collection[indexPath.row]
        
        if let item = item {
            itemListDelegate?.didSelectItem(self, item: item)
        }
    }
    
    private func descriptionForItem(item: Item) -> NSAttributedString {
        let description = NSMutableAttributedString()
                        
        if item.damage.characters.count > 0 {
            let damageString = NSAttributedString.attributedStringWithBodyAttributes("Damage: " + item.damage)
            
            description.appendAttributedString(damageString)
        }
        
        if item.effects.characters.count > 0 {
            let effectsString = NSAttributedString.attributedStringWithBodyAttributes("\n\n" + item.effects)
            
            description.appendAttributedString(effectsString)
        }
        
        if item.flavor.characters.count > 0 {
            let flavorString = NSAttributedString.attributedStringWithSmallAttributes("\n\n" + item.flavor)
            
            description.appendAttributedString(flavorString)
        }
        
        return description
    }
}
