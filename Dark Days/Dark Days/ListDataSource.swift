//
//  ListDataSource.swift
//  Dark Days
//
//  Created by Andrew Harrison on 2/22/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import UIKit

final class ListDataSource<T, U where U: UITableViewCell>: NSObject, UITableViewDataSource {
    
    typealias TableViewCellConfigureBlock = (cell: U, object: T?) -> Void

    let collection: [T]
    let configureCell: TableViewCellConfigureBlock
    
    init(collection: [T], configureCell: TableViewCellConfigureBlock) {
        self.collection = collection
        self.configureCell = configureCell
        
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = collection[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(U.self, type: .Cell)
        
        configureCell(cell: cell, object: object)
        
        return cell
    }
}
