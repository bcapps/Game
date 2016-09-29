//
//  ItemSetListViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 9/29/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class ItemSetListViewController: UITableViewController {
    
    var hero: Hero? {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .backgroundColor()
        tableView.separatorColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemSetCell")
        tableView.tableFooterView = UIView()
        tableView.contentInset = .zero
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hero?.inventory.equippedItemSets.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSetCell", for: indexPath)
        guard let itemSet = hero?.inventory.equippedItemSets[indexPath.row] else { return cell }
        
        cell.textLabel?.attributedText = attributedItemSetTitle(itemSet: itemSet)
        cell.backgroundColor = .backgroundColor()
        
        return cell
    }
    
    private func attributedItemSetTitle(itemSet: ItemSet) -> NSAttributedString {
        let attributes = [NSFontAttributeName: UIFont.smallFont(), NSForegroundColorAttributeName: UIColor.bodyTextColor()]
        
        return NSAttributedString(string: itemSet.name, attributes: attributes)
    }
}
