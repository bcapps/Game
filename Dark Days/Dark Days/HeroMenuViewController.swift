//
//  HeroMenuViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/28/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class HeroMenuViewController: UITableViewController {
    
    private enum HeroMenu: String {
        case Items
        case Skills
        case Spells
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor()
        tableView.rowHeight = 64
        
        tableView.registerNib(HeroMenuCell.nib, aClass: HeroMenuCell.self, type: .Cell)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(HeroMenuCell.self, type: .Cell)
        
        cell.imageView?.image = UIImage(named: "Elf")
        cell.textLabel?.text = "Hello"
        
        return cell
    }
}
