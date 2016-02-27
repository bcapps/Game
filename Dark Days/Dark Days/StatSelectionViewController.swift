//
//  StatSelectionViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/26/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class StatSelectionViewController: ListViewController<Stat> {
    
    var selectedStats = [Stat]()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedStat = objects[indexPath.row]

        selectedStats.append(selectedStat)
        
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let deselectedStat = objects[indexPath.row]
        
        selectedStats.removeObject(deselectedStat)
    }
}
